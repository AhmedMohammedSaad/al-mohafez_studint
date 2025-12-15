import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tutor_model.dart';

class TeachersRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<TutorModel>> getTeachers({String? gender}) async {
    try {
      var query = _supabase.from('teachers').select();

      if (gender != null) {
        query = query.eq('gender', gender);
      }

      final List<dynamic> data = await query;

      return data.map((json) => TutorModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch teachers: $e');
    }
  }
}
