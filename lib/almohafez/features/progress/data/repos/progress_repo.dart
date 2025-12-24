import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/data/models/session_evaluation_model.dart';
import '../models/progress_model.dart';

class ProgressRepo {
  final _supabase = Supabase.instance.client;

  Future<ProgressModel> getStudentProgress() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return ProgressModel(
        overallProgress: 0,
        dailyPerformance: [],
        recentSessions: [],
        teacherNotes: [],
        hasError: true,
        errorMessage: 'User not authenticated',
      );
    }

    try {
      // 1. Fetch all bookings for the student
      final response = await _supabase
          .from('bookings')
          .select('*, teachers(*)')
          .eq('student_id', userId)
          .order('selected_date', ascending: false);
      print('Evaluations: $response');
      final List<dynamic> data = response;

      if (data.isEmpty) {
        return ProgressModel(
          overallProgress: 0,
          dailyPerformance: [],
          recentSessions: [],
          teacherNotes: [],
        );
      }

      // 2. Fetch Session Evaluations (Fix for RLS issue: Ensure policy allows this)
      List<SessionEvaluation> evaluations = [];
      try {
        final evalResponse = await _supabase
            .from('session_evaluations')
            .select()
            .eq('student_id', userId);

        evaluations = (evalResponse as List)
            .map((e) => SessionEvaluation.fromJson(e))
            .toList();
      } catch (e) {
        print('Error fetching evaluations: $e');
        // Continue without evaluations if error (e.g. RLS strict)
      }

      // Map bookings by ID for teacher lookup
      final bookingsMap = {for (var b in data) b['id'] as String: b};

      // 3. Process Data

      List<RecentSession> recentSessions = [];
      List<TeacherNote> teacherNotes = [];
      Map<String, List<double>> dailyRatings = {};

      // Track processed sessions to avoid double counting if we mix sources
      final Set<String> evaluatedBookingIds = {};

      // A. Process All Evaluations (Primary: Show all rows)
      for (var evaluation in evaluations) {
        evaluatedBookingIds.add(evaluation.sessionId);

        // Get Teacher Name from booking
        String teacherName = 'Unknown';
        final booking = bookingsMap[evaluation.sessionId];
        String dateStr = evaluation.createdAt.toIso8601String().split('T')[0];

        if (booking != null) {
          final teacherData = booking['teachers'];
          if (teacherData != null) {
            teacherName =
                teacherData['full_name'] ??
                '${teacherData['first_name'] ?? ''} ${teacherData['last_name'] ?? ''}'
                    .trim();
          }
          // Use booking date only if evaluation date seems wrong?
          // Actually, evaluation created_at is the most accurate "when did this happen" date.
          // But usually we group by session date. Currently using evaluation date to distinguish rows if they happen on different days.
        }

        final rating = evaluation.overallScore ?? 5;

        recentSessions.add(
          RecentSession(
            date: dateStr,
            teacherName: teacherName,
            rating: rating,
            maxRating: 5,
          ),
        );

        if (!dailyRatings.containsKey(dateStr)) {
          dailyRatings[dateStr] = [];
        }
        double sessionScore = (rating.toDouble() / 5.0) * 100.0;
        dailyRatings[dateStr]!.add(sessionScore);

        if (evaluation.notes != null && evaluation.notes!.isNotEmpty) {
          teacherNotes.add(
            TeacherNote(note: evaluation.notes!, timestamp: dateStr),
          );
        }
      }

      // B. Process Bookings (Fallback for sessions with NO evaluations)
      for (var booking in data) {
        final bookingId = booking['id'] as String;

        // Skip if we already showed this session via an evaluation
        // NOTE: If a session has 2 evaluations, we showed 2 rows above.
        // We do NOT want to show a 3rd row for the booking itself.
        if (evaluatedBookingIds.contains(bookingId)) continue;

        final status = booking['status'] as String? ?? '';
        bool actuallyCompleted = status == 'completed';

        if (!actuallyCompleted && status == 'confirmed') {
          try {
            final dateStr = booking['selected_date'] as String;
            final date = DateTime.parse(dateStr);
            if (date.isBefore(DateTime.now())) {
              actuallyCompleted = true;
            }
          } catch (_) {}
        }

        if (actuallyCompleted) {
          final teacherData = booking['teachers'];
          String teacherName = 'Unknown';
          if (teacherData != null) {
            teacherName =
                teacherData['full_name'] ??
                '${teacherData['first_name'] ?? ''} ${teacherData['last_name'] ?? ''}'
                    .trim();
          }

          final rating = (booking['rating'] as num?)?.toInt() ?? 5;
          final dateStr = booking['selected_date'] as String;

          recentSessions.add(
            RecentSession(
              date: dateStr,
              teacherName: teacherName,
              rating: rating,
              maxRating: 5,
            ),
          );

          if (!dailyRatings.containsKey(dateStr)) {
            dailyRatings[dateStr] = [];
          }
          double sessionScore = (rating.toDouble() / 5.0) * 100.0;
          dailyRatings[dateStr]!.add(sessionScore);

          final tutorNotes = booking['tutor_notes'] as String?;
          if (tutorNotes != null && tutorNotes.isNotEmpty) {
            teacherNotes.add(TeacherNote(note: tutorNotes, timestamp: dateStr));
          }
        }
      }

      // Calculate Overall Progress
      // User requested logical average.
      // Instead of (Completed / Total Bookings), which can exceed 100% if multiple evaluations exist per booking,
      // we should calculate the Average Score (Performance) across all recorded sessions/evaluations.

      double totalScoreSum = 0;
      int scoreCount = 0;

      // Aggregate from dailyRatings which holds all individual session scores (in %)
      dailyRatings.forEach((_, scores) {
        for (var score in scores) {
          totalScoreSum += score;
          scoreCount++;
        }
      });

      double overallProgress = scoreCount > 0 ? totalScoreSum / scoreCount : 0;

      // Process Daily Performance Map to List
      List<DailyPerformance> dailyPerformance = [];
      dailyRatings.forEach((date, scores) {
        double avg = scores.reduce((a, b) => a + b) / scores.length;
        dailyPerformance.add(
          DailyPerformance(date: date, percentage: avg, dayName: date),
        );
      });

      // Sort and Limit
      dailyPerformance.sort((a, b) => a.date.compareTo(b.date));
      if (dailyPerformance.length > 7) {
        dailyPerformance = dailyPerformance.sublist(
          dailyPerformance.length - 7,
        );
      }

      if (recentSessions.length > 5) {
        recentSessions = recentSessions.sublist(0, 5);
      }

      if (teacherNotes.length > 5) {
        teacherNotes = teacherNotes.sublist(0, 5);
      }

      return ProgressModel(
        overallProgress: overallProgress,
        dailyPerformance: dailyPerformance,
        recentSessions: recentSessions,
        teacherNotes: teacherNotes,
      );
    } catch (e) {
      print('Error processing progress data: $e');
      return ProgressModel(
        overallProgress: 0,
        dailyPerformance: [],
        recentSessions: [],
        teacherNotes: [],
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
