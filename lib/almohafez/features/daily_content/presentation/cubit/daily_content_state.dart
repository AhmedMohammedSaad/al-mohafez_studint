import 'package:equatable/equatable.dart';
import '../../domain/entities/video_entity.dart';

enum DailyContentStatus { initial, loading, success, failure }

class DailyContentState extends Equatable {
  final DailyContentStatus status;
  final List<VideoEntity> videos;
  final String? nextPageToken;
  final bool hasReachedMax;
  final String? errorMessage;

  // Track current search/session context for pagination
  final String? currentQuery;
  final String? currentChannelId;

  const DailyContentState({
    this.status = DailyContentStatus.initial,
    this.videos = const [],
    this.nextPageToken,
    this.hasReachedMax = false,
    this.errorMessage,
    this.currentQuery,
    this.currentChannelId,
  });

  DailyContentState copyWith({
    DailyContentStatus? status,
    List<VideoEntity>? videos,
    String? nextPageToken,
    bool? hasReachedMax,
    String? errorMessage,
    String? currentQuery,
    String? currentChannelId,
  }) {
    return DailyContentState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      currentQuery: currentQuery ?? this.currentQuery,
      currentChannelId: currentChannelId ?? this.currentChannelId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    videos,
    nextPageToken,
    hasReachedMax,
    errorMessage,
    currentQuery,
    currentChannelId,
  ];
}
