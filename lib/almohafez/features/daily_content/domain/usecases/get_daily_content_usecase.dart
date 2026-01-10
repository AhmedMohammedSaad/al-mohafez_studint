import 'package:dartz/dartz.dart';
import '../entities/video_response_entity.dart';
import '../repositories/daily_content_repo.dart';

class GetDailyContentUseCase {
  final DailyContentRepository repository;

  GetDailyContentUseCase(this.repository);

  Future<Either<String, VideoResponseEntity>> call({
    String? query,
    String? channelId,
    String? pageToken,
  }) {
    return repository.fetchVideos(
      query: query,
      channelId: channelId,
      pageToken: pageToken,
    );
  }
}
