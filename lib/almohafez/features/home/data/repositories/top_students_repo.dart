import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/top_student_model.dart';

class TopStudentsRepo {
  final SupabaseClient _supabase;

  TopStudentsRepo(this._supabase);

  /// Get top students globally (for student view - shows all top students across all teachers)
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
}
