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
    if (state.status == DailyContentStatus.loading && !refresh) return;

    String query;
    String? channelId;

    // DETERMINING MODE:
    // If we are already in "Standard Feed" mode (query == ''), keep it.
    // Otherwise (Null, Random, or Specific Search), default to Random Feed on refresh/init.

    bool isStandardFeed = state.currentQuery == '';

    if (isStandardFeed && refresh) {
      query = '';
      channelId = null;
    } else if (refresh || state.currentQuery == null) {
      // Default to Random Feed (RPC)
      query = 'random_feed';
      channelId = null;
    } else {
      // Pagination or re-fetch of same context
      query = state.currentQuery!;
      channelId = state.currentChannelId;
    }

    if (refresh) {
      emit(
        state.copyWith(
          status: DailyContentStatus.loading,
          videos: [], // Clear list on refresh
          nextPageToken: null,
        ),
      );
    } else {
      emit(state.copyWith(status: DailyContentStatus.loading));
    }

    final result = await getDailyContentUseCase(
      query: query,
      channelId: channelId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DailyContentStatus.failure,
          errorMessage: failure,
        ),
      ),
      (response) {
        // If random feed returns empty (rare), we could handle retry, but RPC usually returns something.
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
      },
    );
  }

  /// Fetches the full list of content (Standard Chronological Feed)
  /// Used for "Show All" screen to support pagination.
  /// Fetches the full list of content (Standard Chronological Feed)
  /// Used for "Show All" screen to support pagination.
  Future<void> fetchAllContent() async {
    emit(
      state.copyWith(
        status: DailyContentStatus.loading,
        videos: [],
        nextPageToken: null, // Reset for fresh start
        currentQuery:
            'random_feed', // Use Random Feed for Show All too (per user request)
        currentChannelId: null,
      ),
    );

    // User requested "Random from Flutter side" and "Bottom to Top".
    // Using 'random_feed' (RPC) gets us random videos from the DB (server-side shuffle).
    // This is better than client-side sorting of just 20 items.
    // We effectively get a random page.
    final result = await getDailyContentUseCase(
      query: 'random_feed',
      channelId: null,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DailyContentStatus.failure,
          errorMessage: failure,
        ),
      ),
      (response) {
        // Additional Shuffle on Client Side (Flutter) as requested explicitly
        final shuffledVideos = List.of(response.videos)..shuffle();

        emit(
          state.copyWith(
            status: DailyContentStatus.success,
            videos: shuffledVideos,
            nextPageToken: response.nextPageToken,
            hasReachedMax: response.nextPageToken == null,
            currentQuery: 'random_feed',
            currentChannelId: null,
          ),
        );
      },
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
