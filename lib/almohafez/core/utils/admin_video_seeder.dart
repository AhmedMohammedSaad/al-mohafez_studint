import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A utility class to seed the Supabase database with YouTube content.
/// This should only be used by admins or developers to populate the `youtube_videos` table.
///
/// **WARNING**: This consumes YouTube API Quota.
class AdminVideoSeeder {
  // Temporary API Key for Seeding (Provided by User)
  // Ensure this is valid and has quota.
  static const String _seederApiKey = 'AIzaSyBDA1sk_K6wdZdL6KWwZ2eT1zP9QCvGuE8';

  final Dio _dio = Dio();
  final SupabaseClient _supabase = Supabase.instance.client;

  final List<String> _sheikhs = [
    'بودكاست ديني',
    'تفسير القرآن الكريم',
    'السيرة النبوية',
    'قصص الأنبياء',
  ];

  Future<void> seedDatabase() async {
    log('🌱 STARTING DATABASE SEEDING PROCESS...');
    int totalInserted = 0;

    // Pick 3 random topics/sheikhs to fetch this time
    // This saves quota and adds variety on each refresh
    final pool = List<String>.from(_sheikhs)..shuffle();
    final selectedQueries = pool.take(3).toList();

    log('🎲 Selected Queries for this run: $selectedQueries');

    for (final query in selectedQueries) {
      log('🔍 Fetching videos for: $query');
      try {
        List<Map<String, dynamic>> videos = await _fetchVideosForQuery(query);

        if (videos.isEmpty) {
          log('⚠️ No videos found for $query');
          continue;
        }

        // Upsert to Supabase
        await _upsertToSupabase(videos);
        totalInserted += videos.length;
        log('✅ Successfully inserted ${videos.length} videos for $query');
      } catch (e) {
        log('❌ Error processing $query: $e');
      }
    }

    log('🎉 SEEDING COMPLETE! Total Videos Inserted/Updated: $totalInserted');
  }

  Future<List<Map<String, dynamic>>> _fetchVideosForQuery(String query) async {
    List<Map<String, dynamic>> allVideos = [];
    String? nextPageToken;
    int maxPages =
        4; // Fetch approx 4 pages * 10-15 results = ~50 videos per sheikh

    for (int i = 0; i < maxPages; i++) {
      try {
        final queryParams = {
          'part': 'snippet',
          'q': query,
          'type': 'video',
          'key': _seederApiKey,
          'maxResults':
              15, // Max 50, but let's do 15 to get variety across pages
          'order':
              'relevance', // relevance allows for better "related" hits than just date
          'relevanceLanguage': 'ar',
          'videoDuration': 'medium', // 4-20 mins
          'safeSearch': 'strict',
        };

        if (nextPageToken != null) {
          queryParams['pageToken'] = nextPageToken;
        }

        final response = await _dio.get(
          'https://www.googleapis.com/youtube/v3/search',
          queryParameters: queryParams,
        );

        if (response.statusCode == 200) {
          final data = response.data;
          // log('🔥 FULL API DATA: $data');
          final items = data['items'] as List;

          for (var item in items) {
            final snippet = item['snippet'];
            final videoId = item['id']['videoId'];

            if (videoId == null) continue;

            allVideos.add({
              'video_id': videoId,
              'title': snippet['title'],
              'description': snippet['description'],
              'thumbnail_url':
                  snippet['thumbnails']['high']['url'] ??
                  snippet['thumbnails']['medium']['url'],
              'channel_name': snippet['channelTitle'],
              'published_at': snippet['publishedAt'],
              'fetched_at': DateTime.now()
                  .toIso8601String(), // Current timestamp
            });
          }

          nextPageToken = data['nextPageToken'];
          if (nextPageToken == null) break; // No more pages
        } else {
          log(
            '⚠️ API Error fetching page $i for $query: ${response.statusCode}',
          );
          break;
        }
      } catch (e) {
        log('⚠️ Exception fetching page $i for $query: $e');
        break;
      }
    }

    // Deduplication logic: ensure unique video_id
    final uniqueVideosMap = <String, Map<String, dynamic>>{};
    for (var video in allVideos) {
      final id = video['video_id'] as String;
      uniqueVideosMap[id] = video;
    }

    return uniqueVideosMap.values.toList();
  }

  Future<void> _upsertToSupabase(List<Map<String, dynamic>> videos) async {
    try {
      // Supabase .upsert() handles conflict on primary/unique keys (video_id)
      final response = await _supabase
          .from('youtube_videos')
          .upsert(
            videos,
            onConflict:
                'video_id', // Ensure this matches the unique constraint in SQL
          )
          .select(); // Select to return data and confirm success

      // Log IDs
      for (var row in response) {
        log(
          '   📌 Upserted: [${row['video_id']}] ${row['title'].toString().substring(0, 20)}...',
        );
      }
    } catch (e) {
      log('❌ Supabase Upsert Error: $e');
      throw e; // Rethrow to stop this sheikh's batch if DB fails
    }
  }
}
