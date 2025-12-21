import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/competition_model.dart';

class CompetitionsRepo {
  final SupabaseClient _supabase;

  CompetitionsRepo(this._supabase);

  /// Get all active competitions
  Future<List<Competition>> getCompetitions() async {
    try {
      final response = await _supabase
          .from('competitions')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map<Competition>((e) => Competition.fromJson(e))
          .toList();
    } catch (e) {
      log('Error fetching competitions: $e');
      return [];
    }
  }

  /// Get single active competition (for displaying one at a time)
  Future<Competition?> getCurrentCompetition() async {
    try {
      final response = await _supabase
          .from('competitions')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return Competition.fromJson(response);
    } catch (e) {
      log('Error fetching current competition: $e');
      return null;
    }
  }
}
