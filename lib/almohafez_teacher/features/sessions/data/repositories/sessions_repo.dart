import 'package:nb_utils/nb_utils.dart';
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

      final bookings = response as List;
      if (bookings.isEmpty) return [];

      // Extract unique student IDs
      final studentIds = bookings
          .map((e) => e['student_id'])
          .where((id) => id != null)
          .cast<String>()
          .toSet()
          .toList();

      // Fetch student profiles to get real names
      Map<String, String> studentNames = {};
      if (studentIds.isNotEmpty) {
        final profiles = await _supabase
            .from('profiles')
            .select('id, first_name, last_name')
            .inFilter('id', studentIds);

        for (var profile in profiles) {
          final id = profile['id'] as String;
          final firstName = profile['first_name'] ?? '';
          final lastName = profile['last_name'] ?? '';
          studentNames[id] = '$firstName $lastName'.trim();
        }
      }

      return bookings.map<Session>((e) {
        final studentId = e['student_id'] as String?;
        // Use profile name if available, fallback to booking student_name
        String studentName = e['student_name'] ?? '';
        if (studentId != null && studentNames.containsKey(studentId)) {
          final profileName = studentNames[studentId]!;
          if (profileName.isNotEmpty) {
            studentName = profileName;
          }
        }

        // Create modified json with updated student_name
        final modifiedJson = Map<String, dynamic>.from(e);
        modifiedJson['student_name'] = studentName;

        return Session.fromJson(modifiedJson);
      }).toList();
    } catch (e) {
      log('Error fetching sessions: $e');
      return [];
    }
  }

  Future<void> updateMeetingUrl(String sessionId, String meetingUrl) async {
    try {
      await _supabase
          .from('bookings')
          .update({'meeting_url': meetingUrl})
          .eq('id', sessionId);
    } catch (e) {
      log('Error updating meeting url: $e');
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
