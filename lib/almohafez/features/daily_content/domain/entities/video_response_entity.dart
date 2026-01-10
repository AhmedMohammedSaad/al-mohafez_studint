import 'package:equatable/equatable.dart';
import 'video_entity.dart';

class VideoResponseEntity extends Equatable {
  final List<VideoEntity> videos;
  final String? nextPageToken;

  const VideoResponseEntity({required this.videos, this.nextPageToken});

  @override
  List<Object?> get props => [videos, nextPageToken];
}
