import 'package:supabase_flutter/supabase_flutter.dart';

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
}
