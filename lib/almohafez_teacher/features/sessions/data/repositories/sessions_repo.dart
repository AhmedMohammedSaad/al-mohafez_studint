import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import '../models/session_model.dart';

class SessionsRepo {
  final SupabaseClient _supabase;

  SessionsRepo(this._supabase);

  Future<List<Session>> getSessions() async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('teacher_id', userId)
          .order('selected_date', ascending: true);

      return (response as List)
          .map<Session>((e) => Session.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
  }

  Future<void> updateMeetingUrl(String sessionId, String meetingUrl) async {
    try {
      await _supabase
          .from('bookings')
          .update({
            'meeting_url': meetingUrl,
            'status':
                'inProgress', // Optional: auto change status to inProgress
          })
          .eq('id', sessionId);
    } catch (e) {
      print('Error updating meeting url: $e');
      throw Exception('Failed to update meeting url');
    }
  }

  Future<void> updateSessionStatus(String sessionId, String status) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': status})
          .eq('id', sessionId);
    } catch (e) {
      print('Error updating session status: $e');
      throw Exception('Failed to update status');
    }
  }
}
