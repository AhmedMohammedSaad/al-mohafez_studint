import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final DateTime publishedAt;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    thumbnailUrl,
    channelTitle,
    publishedAt,
  ];
}
