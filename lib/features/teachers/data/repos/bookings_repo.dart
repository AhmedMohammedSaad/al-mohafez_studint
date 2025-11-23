import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';
import '../models/booking_request_model.dart';

class BookingsRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> createBooking(BookingRequestModel request) async {
    try {
      final response = await _supabase
          .from('bookings')
          .insert(request.toJson())
          .select()
          .single();

      return response['id'] as String;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<BookingModel> getBookingById(String id) async {
    try {
      final data = await _supabase
          .from('bookings')
          .select()
          .eq('id', id)
          .single();

      return BookingModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  Future<List<BookingModel>> getStudentBookings(String studentId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('bookings')
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch student bookings: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  Future<List<BookingModel>> getTeacherBookings(String teacherId) async {
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);

      final List<dynamic> data = await _supabase
          .from('bookings')
          .select()
          .eq('teacher_id', teacherId)
          .neq('status', 'cancelled') // Only active bookings
          .gte(
            'selected_date',
            startOfToday.toIso8601String(),
          ); // Future bookings including today

      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch teacher bookings: $e');
    }
  }

  Future<void> rateSession({
    required String sessionId,
    required String tutorId,
    required double rating,
    String? comment,
    List<String>? tags,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase.from('session_ratings').insert({
        'session_id': sessionId,
        'student_id': userId,
        'tutor_id': tutorId,
        'rating': rating,
        'feedback': comment,
        'tags': tags,
      });
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }
}
