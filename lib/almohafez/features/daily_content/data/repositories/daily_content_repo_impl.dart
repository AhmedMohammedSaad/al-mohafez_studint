import 'package:dartz/dartz.dart';
import '../../domain/entities/video_response_entity.dart';
import '../../domain/repositories/daily_content_repo.dart';
import '../datasources/daily_content_remote_datasource.dart';

class DailyContentRepositoryImpl implements DailyContentRepository {
  final DailyContentRemoteDataSource remoteDataSource;

  DailyContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, VideoResponseEntity>> fetchVideos({
    String? query,
    String? channelId,
    String? pageToken,
  }) async {
    try {
      final result = await remoteDataSource.getVideos(
        query ?? 'القرآن الكريم',
        channelId: channelId,
        pageToken: pageToken,
      );

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
