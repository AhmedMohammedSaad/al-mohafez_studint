import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session_model.dart';

class SessionsRepo {
  final _supabase = Supabase.instance.client;

  Future<List<SessionModel>> getStudentSessions() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      // Fetch bookings for the student
      final response = await _supabase
          .from('bookings')
          .select('*, teachers(*)') // Join with teachers table
          .eq('student_id', userId)
          .order('selected_date', ascending: true); // Order by date

      final List<dynamic> data = response;
      print('Sessions Data: $data'); // Debug log

      return data.map((json) => _mapJsonToSession(json)).toList();
    } catch (e) {
      print('Error fetching sessions: $e');
      throw Exception('Failed to load sessions');
    }
  }

  Future<SessionModel?> getSessionById(String sessionId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select('*, teachers(*)')
          .eq('id', sessionId)
          .single();

      return _mapJsonToSession(response);
    } catch (e) {
      print('Error fetching session by id: $e');
      return null;
    }
  }

  SessionModel _mapJsonToSession(Map<String, dynamic> json) {
    final teacherData = json['teachers'];
    String tutorName = 'Unknown Tutor';
    String tutorImage = 'assets/images/tutor1.jpg';

    if (teacherData != null) {
      // Try full_name first, then combine first/last if available
      if (teacherData['full_name'] != null) {
        tutorName = teacherData['full_name'];
      } else if (teacherData['first_name'] != null) {
        tutorName =
            '${teacherData['first_name']} ${teacherData['last_name'] ?? ''}'
                .trim();
      }

      if (teacherData['image'] != null) {
        tutorImage = teacherData['image'];
      } else if (teacherData['profile_picture_url'] != null) {
        tutorImage = teacherData['profile_picture_url'];
      }
    }

    // Parse date and time
    // selected_date is YYYY-MM-DD
    // selected_time_slot is "HH:mm - HH:mm"
    DateTime selectedDate = DateTime.parse(json['selected_date']);
    final timeSlot = json['selected_time_slot'] as String;

    try {
      final startTimeStr = timeSlot.split('-')[0].trim(); // "16:00"
      final parts = startTimeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );
    } catch (e) {
      print('Error parsing time slot: $timeSlot');
    }

    // Map booking status to SessionStatus
    SessionStatus status;
    final bookingStatus = json['status'] as String;
    final now = DateTime.now();

    if (bookingStatus == 'cancelled') {
      status = SessionStatus.cancelled;
    } else if (selectedDate.isBefore(now) && bookingStatus == 'confirmed') {
      // Assuming past confirmed bookings are completed
      status = SessionStatus.completed;
    } else {
      status = SessionStatus.upcoming;
    }

    return SessionModel(
      id: json['id'],
      tutorId: json['teacher_id'],
      tutorName: tutorName,
      tutorImageUrl: tutorImage,
      studentId: json['student_id'],
      type: SessionType.recitation, // Default
      mode: SessionMode.online,
      scheduledDateTime: selectedDate,
      durationMinutes: 60, // Default to 60 mins
      status: status,
      meetingUrl: json['meeting_url'],
      notes: json['notes'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      feedback: json['feedback'],
      tutorNotes: json['tutor_notes'],
    );
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
      if (userId == null) throw Exception('User not authenticated');

      // Get current teacher data
      final teacherData = await _supabase
          .from('teachers')
          .select('overall_rating, comments')
          .eq('id', tutorId)
          .single();

      // Prepare updated comments list
      List<dynamic> comments = teacherData['comments'] ?? [];
      if (comment != null && comment.isNotEmpty) {
        comments.add({
          'student_id': userId,
          'session_id': sessionId,
          'comment': comment,
          'rating': rating,
          'tags': tags ?? [],
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // Calculate new overall rating (average of all ratings in comments)
      double newOverallRating = rating;
      if (comments.isNotEmpty) {
        double totalRating = 0;
        int count = 0;
        for (var c in comments) {
          if (c['rating'] != null) {
            totalRating += (c['rating'] as num).toDouble();
            count++;
          }
        }
        if (count > 0) {
          newOverallRating = totalRating / count;
        }
      }

      // Update teacher with new rating and comments
      await _supabase
          .from('teachers')
          .update({'overall_rating': newOverallRating, 'comments': comments})
          .eq('id', tutorId);

      // --- New: Insert into teacher_ratings ---
      try {
        // Fetch student name
        String studentName = 'Unknown';
        try {
          final profileData = await _supabase
              .from('profiles')
              .select('first_name, last_name')
              .eq('id', userId)
              .single();
          studentName =
              '${profileData['first_name']} ${profileData['last_name'] ?? ''}'
                  .trim();
        } catch (e) {
          print('Error fetching student name: $e');
        }

        // Insert into teacher_ratings
        await _supabase.from('teacher_ratings').insert({
          'student_id': userId,
          'student_name': studentName,
          'teacher_id': tutorId,
          'rating': rating.round(), // Assuming int4 as per schema description
          'session_id': sessionId,
          'comment': comment,
          // 'created_at': default now()
        });
      } catch (e) {
        print('Error inserting into teacher_ratings: $e');
        // We log but don't rethrow to ensure the other updates (bookings) usually succeed
        // or rethrow if this is critical. Assuming critical for now?
        // Actually, if this fails, we might still want the booking to be marked rated.
        // But let's log it.
      }
      // ----------------------------------------

      // Also update the specific session (booking) with the rating
      await _updateSessionRating(sessionId, rating, comment);
    } catch (e) {
      print('Error submitting rating: $e');
      throw Exception('Failed to submit rating: $e');
    }
  }

  Future<void> _updateSessionRating(
    String sessionId,
    double rating,
    String? comment,
  ) async {
    await _supabase
        .from('bookings')
        .update({'rating': rating, 'feedback': comment})
        .eq('id', sessionId);
  }
}
