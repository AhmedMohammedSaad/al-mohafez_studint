import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/top_student_model.dart';

class TopStudentsRepo {
  final SupabaseClient _supabase;

  TopStudentsRepo(this._supabase);

  /// Get top students globally, ordered by progress (highest first)
  Future<List<TopStudent>> getTopStudents({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('top_students')
          .select()
          .order('progress', ascending: false)
          .limit(limit);

      return (response as List)
          .map<TopStudent>((e) => TopStudent.fromJson(e))
          .toList();
    } catch (e) {
      log('Error fetching top students: $e');
      return [];
    }
  }

  /// Add a new top student record
  Future<TopStudent?> addTopStudent({
    required String studentId,
    required String name,
    required double progress,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      final response = await _supabase
          .from('top_students')
          .insert({
            'student_id': studentId,
            'teacher_id': userId,
            'name': name,
            'progress': progress,
          })
          .select()
          .single();

      return TopStudent.fromJson(response);
    } catch (e) {
      log('Error adding top student: $e');
      return null;
    }
  }

  /// Update the progress of an existing top student record
  Future<bool> updateStudentProgress(String id, double progress) async {
    try {
      await _supabase
          .from('top_students')
          .update({
            'progress': progress,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
      return true;
    } catch (e) {
      log('Error updating student progress: $e');
      return false;
    }
  }

  /// Delete a top student record
  Future<bool> deleteTopStudent(String id) async {
    try {
      await _supabase.from('top_students').delete().eq('id', id);
      return true;
    } catch (e) {
      log('Error deleting top student: $e');
      return false;
    }
  }
}
