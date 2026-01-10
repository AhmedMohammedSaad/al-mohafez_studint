import '../../domain/entities/video_response_entity.dart';
import 'video_model.dart';

class VideoResponseModel extends VideoResponseEntity {
  const VideoResponseModel({required super.videos, super.nextPageToken});

  factory VideoResponseModel.fromJson(Map<String, dynamic> json) {
    return VideoResponseModel(
      videos: (json['items'] as List)
          .map((e) => VideoModel.fromJson(e))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
    );
  }
}
