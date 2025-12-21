import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/teacher_rating_model.dart';

class TeacherRatingsRepo {
  final SupabaseClient _supabase;

  TeacherRatingsRepo(this._supabase);

  /// Get all ratings for the current teacher
  Future<List<TeacherRating>> getTeacherRatings() async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      final response = await _supabase
          .from('teacher_ratings')
          .select()
          .eq('teacher_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map<TeacherRating>((e) => TeacherRating.fromJson(e))
          .toList();
    } catch (e) {
      log('Error fetching teacher ratings: $e');
      return [];
    }
  }

  /// Get average rating for the current teacher
  Future<double> getAverageRating() async {
    final ratings = await getTeacherRatings();
    if (ratings.isEmpty) return 0.0;

    final total = ratings.fold<int>(0, (sum, r) => sum + r.rating);
    return total / ratings.length;
  }
}
