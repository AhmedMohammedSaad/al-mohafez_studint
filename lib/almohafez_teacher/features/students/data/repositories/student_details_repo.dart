import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../sessions/data/models/session_evaluation_model.dart';

class StudentDetailsRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getStudentBookings(
    String studentId,
  ) async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      final bookings = await _supabase
          .from('bookings')
          .select()
          .eq('teacher_id', userId)
          .eq('student_id', studentId)
          .order('selected_date', ascending: false);

      return List<Map<String, dynamic>>.from(bookings);
    } catch (e) {
      print('Error fetching student bookings: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getStudentStats(String studentId) async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      final bookings = await _supabase
          .from('bookings')
          .select()
          .eq('teacher_id', userId)
          .eq('student_id', studentId);

      final totalSessions = bookings.length;
      // You can add more stats logic here (e.g. pending, completed)

      return {'totalSessions': totalSessions};
    } catch (e) {
      print('Error fetching student stats: $e');
      return {'totalSessions': 0};
    }
  }

  /// Get all session evaluations for a student
  Future<List<SessionEvaluation>> getStudentEvaluations(
    String studentId,
  ) async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      final response = await _supabase
          .from('session_evaluations')
          .select()
          .eq('teacher_id', userId)
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      return (response as List)
          .map<SessionEvaluation>((e) => SessionEvaluation.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching student evaluations: $e');
      return [];
    }
  }

  /// Calculate average rating from evaluations
  double calculateAverageRating(List<SessionEvaluation> evaluations) {
    if (evaluations.isEmpty) return 0.0;

    double totalScore = 0;
    int count = 0;

    for (final eval in evaluations) {
      if (eval.overallScore != null) {
        totalScore += eval.overallScore!;
        count++;
      }
    }

    return count > 0 ? totalScore / count : 0.0;
  }
}
