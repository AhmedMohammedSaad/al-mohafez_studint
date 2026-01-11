import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/video_response_model.dart';

abstract class DailyContentRemoteDataSource {
  Future<VideoResponseModel> getVideos(
    String query, {
    String? channelId,
    String? pageToken,
  });
}

class DailyContentRemoteDataSourceImpl implements DailyContentRemoteDataSource {
  final SupabaseClient supabaseClient;

  DailyContentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<VideoResponseModel> getVideos(
    String query, {
    String? channelId,
    String? pageToken,
  }) async {
    try {
      final int limit = 20;
      final int offset = int.tryParse(pageToken ?? '0') ?? 0;

      log('Fetching Supabase Content: Query="$query", Offset=$offset');

      List<dynamic> data;

      // 1. RANDOM FEED LOGIC (Refreshes on Main Screen)
      // Check for a special keywords or if this is an initial random fetch
      // User asked for random on refresh.
      // We can use a special query flag or just assume "empty query" & "offset 0" & "channelId" is empty means random feed?
      // Let's explicitly handle a "random" query string for clarity in Cubit.
      if (query == 'random_feed') {
        // RPC call for random videos
        data = await supabaseClient.rpc(
          'get_random_videos',
          params: {'limit_count': limit},
        );
      } else {
        // 2. STANDARD PAGINATION / SEARCH (Show All Screen)
        var dbQuery = supabaseClient.from('youtube_videos').select();

        if (query.isNotEmpty && query != 'random_feed') {
          dbQuery = dbQuery.ilike('title', '%$query%');
        }

        // Apply Pagination
        data = await dbQuery
            .order('published_at', ascending: false)
            .range(offset, offset + limit - 1);
      }

      log('Supabase returned ${data.length} videos.');

      final List<Map<String, dynamic>> videoItems = (data).map((row) {
        return {
          'id': {'videoId': row['video_id']},
          'snippet': {
            'title': row['title'],
            'description': row['description'],
            'thumbnails': {
              'high': {'url': row['thumbnail_url']},
            },
            'channelTitle': row['channel_name'],
            'publishedAt': row['published_at'],
          },
        };
      }).toList();

      // Determine next page token
      // If we got full limit, we likely have more.
      final String? nextToken = data.length >= limit
          ? (offset + limit).toString()
          : null;

      // If Random, we don't really support pagination easily unless we just fetch another random batch?
      // User wants pagination in "Show All".
      // Random feed usually doesn't need infinite scroll in the widget (it's horizontal).
      // So returning null nextToken for random feed is fine for the widget.

      return VideoResponseModel.fromJson({
        'nextPageToken': query == 'random_feed' ? null : nextToken,
        'items': videoItems,
      });
    } catch (e) {
      log('Supabase Fetch Error: $e');
      throw Exception('Failed to fetch content from Supabase: $e');
    }
  }
}
