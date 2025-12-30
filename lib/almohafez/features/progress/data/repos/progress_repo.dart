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
        allEvaluations: [],
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
          allEvaluations: [],
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
      // Flattened list of scores for 1-to-1 chart mapping
      List<DailyPerformance> dailyPerformance = [];

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

        // Add directly to dailyPerformance (1 chart point = 1 evaluation)
        double sessionScore = (rating.toDouble() / 5.0) * 100.0;
        dailyPerformance.add(
          DailyPerformance(
            date: dateStr,
            percentage: sessionScore,
            dayName: dateStr, // Or format dayName if needed e.g., 'Day X'
          ),
        );

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

          // Add directly to chart data if not already processed via evaluations
          double sessionScore = (rating.toDouble() / 5.0) * 100.0;
          dailyPerformance.add(
            DailyPerformance(
              date: dateStr,
              percentage: sessionScore,
              dayName: dateStr,
            ),
          );

          final tutorNotes = booking['tutor_notes'] as String?;
          if (tutorNotes != null && tutorNotes.isNotEmpty) {
            teacherNotes.add(TeacherNote(note: tutorNotes, timestamp: dateStr));
          }
        }
      }

      // Calculate Overall Progress
      // User requested logical average.
      // Calculate Overall Progress
      // Average Score across all recorded sessions

      double totalScoreSum = 0;
      for (var item in dailyPerformance) {
        totalScoreSum += item.percentage;
      }
      double overallProgress = dailyPerformance.isNotEmpty
          ? totalScoreSum / dailyPerformance.length
          : 0;

      // Sort Chart Data Chronologically (Oldest first for left-to-right chart)
      dailyPerformance.sort((a, b) => a.date.compareTo(b.date));
      // NO LIMIT: User requested "increases with me" for every evaluation added.

      // Clone full list for allEvaluations before slicing
      final allEvaluations = List<RecentSession>.from(recentSessions);
      // Sort allEvaluations by date descending
      allEvaluations.sort((a, b) => b.date.compareTo(a.date));

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
        allEvaluations: allEvaluations,
      );
    } catch (e) {
      print('Error processing progress data: $e');
      return ProgressModel(
        overallProgress: 0,
        dailyPerformance: [],
        recentSessions: [],
        teacherNotes: [],
        allEvaluations: [],
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
