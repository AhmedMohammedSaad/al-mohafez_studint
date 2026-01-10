import 'package:dartz/dartz.dart';

// Assuming AppColors or failure classes might be needed, but strictly for Failure, we need to check if there is a core Failure class.
// Checking imports... usually `core/error/failures.dart` or similar. I'll use a generic Failure for now or valid Dartz types.
// Wait, I should check if there is a Failure class. I'll stick to a simple abstract class first.

import '../entities/video_response_entity.dart';

abstract class DailyContentRepository {
  // For the initial curated preview (top 5) and the full feed
  Future<Either<String, VideoResponseEntity>> fetchVideos({
    String? query,
    String? channelId,
    String? pageToken,
  });
}
