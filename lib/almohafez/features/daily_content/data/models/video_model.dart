import 'package:almohafez/almohafez/features/daily_content/domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.channelTitle,
    required super.publishedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final resourceId = json['id'] is Map ? json['id'] : {};

    return VideoModel(
      id:
          resourceId['videoId'] ??
          json['id'] ??
          '', // Handle both SearchListResponse and direct Video structure
      title: snippet['title'] ?? 'No Title',
      description: snippet['description'] ?? '',
      thumbnailUrl:
          thumbnails['high']?['url'] ??
          thumbnails['medium']?['url'] ??
          thumbnails['default']?['url'] ??
          '',
      channelTitle: snippet['channelTitle'] ?? '',
      publishedAt:
          DateTime.tryParse(snippet['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': {'videoId': id},
      'snippet': {
        'title': title,
        'description': description,
        'thumbnails': {
          'high': {'url': thumbnailUrl},
        },
        'channelTitle': channelTitle,
        'publishedAt': publishedAt.toIso8601String(),
      },
    };
  }
}
