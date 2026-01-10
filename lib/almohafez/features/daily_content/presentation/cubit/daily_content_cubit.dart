import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/video_constants.dart';
import '../../domain/usecases/get_daily_content_usecase.dart';
import 'daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  final GetDailyContentUseCase getDailyContentUseCase;

  DailyContentCubit(this.getDailyContentUseCase)
    : super(const DailyContentState());

  Future<void> fetchDailyContent({bool refresh = false}) async {
    // If loading and not forcing a refresh, ignore.
    if (state.status == DailyContentStatus.loading && !refresh) return;

    // Picking a new random topic/sheikh if refreshing or initializing
    String query;
    String? channelId;
    bool isRetry = false;

    if (refresh || state.currentQuery == null) {
      // DIVERSIFICATION LOGIC:
      final random = Random();
      final sheikh = VideoConstants
          .sheikhNames[random.nextInt(VideoConstants.sheikhNames.length)];
      final topic = VideoConstants
          .searchKeywords[random.nextInt(VideoConstants.searchKeywords.length)];

      channelId = VideoConstants.sheikhChannels[sheikh];
      // Try specific search first
      query = channelId != null ? topic : '$topic $sheikh';

      // Reset state for new fetch
      emit(
        state.copyWith(
          status: DailyContentStatus.loading,
          videos: refresh ? [] : state.videos, // Clear list on refresh
          nextPageToken: null,
        ),
      );
    } else {
      // Pagination or re-fetch of same context
      query = state.currentQuery!;
      channelId = state.currentChannelId;
      emit(state.copyWith(status: DailyContentStatus.loading));
    }

    final result = await getDailyContentUseCase(
      query: query,
      channelId: channelId,
      // If refresh, pageToken should be null (handled by state reset above).
      // If loading more, it's handled in loadMore().
      // This function is primarily for INITIAL or REFRESH.
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DailyContentStatus.failure,
          errorMessage: failure,
        ),
      ),
      (response) async {
        if (response.videos.isEmpty && (refresh || state.videos.isEmpty)) {
          // RETRY LOGIC: If specific search returned nothing, try broader search
          // 1. Try Global Sheikh Search (ignore topic)
          // 2. Try Global Topic Search (ignore sheikh)
          await _retryBroaderSearch(query, channelId);
        } else {
          emit(
            state.copyWith(
              status: DailyContentStatus.success,
              videos: response.videos,
              nextPageToken: response.nextPageToken,
              hasReachedMax: response.nextPageToken == null,
              currentQuery: query,
              currentChannelId: channelId,
            ),
          );
        }
      },
    );
  }

  Future<void> _retryBroaderSearch(
    String originalQuery,
    String? originalChannelId,
  ) async {
    // If we were searching in a specific channel, try searching the Sheikh globally
    final random = Random();
    // Fallback to a very popular topic if all fails
    String newQuery = VideoConstants
        .searchKeywords[random.nextInt(VideoConstants.searchKeywords.length)];
    String? newChannelId = null; // Go global

    // Try to derive sheikh name from context if possible, otherwise just random topic
    // For simplicity, let's just search for a random Sheikh globally
    final sheikh = VideoConstants
        .sheikhNames[random.nextInt(VideoConstants.sheikhNames.length)];
    newQuery = sheikh;

    final result = await getDailyContentUseCase(
      query: newQuery,
      channelId: null,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DailyContentStatus.failure,
          errorMessage: failure,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: DailyContentStatus.success,
          videos: response.videos,
          nextPageToken: response.nextPageToken,
          hasReachedMax: response.nextPageToken == null,
          currentQuery: newQuery,
          currentChannelId: null,
        ),
      ),
    );
  }

  Future<void> searchContent(String query) async {
    if (query.isEmpty) return;

    emit(
      state.copyWith(
        status: DailyContentStatus.loading,
        videos: [], // Clear previous results
        nextPageToken: null, // Reset pagination
      ),
    );

    // When searching, we don't use channelId filter to allow broader results (but still safe/religious)
    // Actually, user might want to search specifically within our trusted circle?
    // User request: "Search". Usually implies global.
    // But we must stick to "Religious Content".
    // We can rely on 'safeSearch' and maybe append "islamic" or "religious" tags invisibly?
    // Or just trust the API params `videoDuration`, `safeSearch`, `relevanceLanguage`.
    // Let's rely on API params + maybe `relevanceLanguage`.

    final result = await getDailyContentUseCase(query: query);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DailyContentStatus.failure,
          errorMessage: failure,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: DailyContentStatus.success,
          videos: response.videos,
          nextPageToken: response.nextPageToken,
          hasReachedMax: response.nextPageToken == null,
          currentQuery: query,
          currentChannelId: null, // Reset channel context for global search
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax || state.status == DailyContentStatus.loading)
      return;
    if (state.nextPageToken == null) return;

    // We don't set status to loading to avoid full screen spinner.
    // We could add a separate `isLoadingMore` flag if we had it.
    // For now, let's just proceed. The UI can check if we are at bottom.
    // Actually, let's rely on the existing state, assuming the UI handles "lazy loading" trigger.

    final result = await getDailyContentUseCase(
      query: state.currentQuery!,
      channelId: state.currentChannelId,
      pageToken: state.nextPageToken,
    );

    result.fold(
      (failure) {
        // For pagination error, maybe show snackbar?
        // We won't disrupt the whole list.
      },
      (response) {
        emit(
          state.copyWith(
            videos: List.of(state.videos)..addAll(response.videos),
            nextPageToken: response.nextPageToken,
            hasReachedMax: response.nextPageToken == null,
          ),
        );
      },
    );
  }
}
