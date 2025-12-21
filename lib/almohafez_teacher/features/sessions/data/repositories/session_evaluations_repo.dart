import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session_evaluation_model.dart';

class SessionEvaluationsRepo {
  final SupabaseClient _supabase;

  SessionEvaluationsRepo(this._supabase);

  /// Get evaluation for a specific session
  Future<SessionEvaluation?> getSessionEvaluation(String sessionId) async {
    try {
      final response = await _supabase
          .from('session_evaluations')
          .select()
          .eq('session_id', sessionId)
          .maybeSingle();

      if (response == null) return null;
      return SessionEvaluation.fromJson(response);
    } catch (e) {
      log('Error fetching session evaluation: $e');
      return null;
    }
  }

  /// Save new session evaluation
  Future<bool> saveEvaluation(SessionEvaluation evaluation) async {
    try {
      await _supabase.from('session_evaluations').insert(evaluation.toJson());
      return true;
    } catch (e) {
      log('Error saving session evaluation: $e');
      return false;
    }
  }

  /// Get all evaluations for a student
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
      log('Error fetching student evaluations: $e');
      return [];
    }
  }
}
