import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_model.dart';

class TeacherStudentsRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Student>> getStudents() async {
    final userId = _supabase.auth.currentUser!.id;

    try {
      // 1️⃣ Get bookings for current teacher with student_name
      final bookings = await _supabase
          .from('bookings')
          .select('student_id, student_name')
          .eq('teacher_id', userId);

      if (bookings.isEmpty) return [];

      // Create a map of student_id -> student_name from bookings
      final Map<String, String> bookingNames = {};
      for (var b in bookings) {
        if (b['student_id'] != null && b['student_name'] != null) {
          bookingNames[b['student_id']] = b['student_name'];
        }
      }

      // 2️⃣ Extract unique student IDs
      final studentIds = bookings
          .map((e) => e['student_id'])
          .where((id) => id != null)
          .cast<String>()
          .toSet()
          .toList();

      if (studentIds.isEmpty) return [];

      // 3️⃣ Fetch students profiles
      final studentsData = await _supabase
          .from('profiles')
          .select()
          .inFilter('id', studentIds);

      // 4️⃣ Fetch evaluations for all students to calculate average ratings
      final evaluations = await _supabase
          .from('session_evaluations')
          .select('student_id, overall_score')
          .eq('teacher_id', userId)
          .inFilter('student_id', studentIds);

      // Calculate average rating per student
      final Map<String, double> studentRatings = {};
      final Map<String, int> studentRatingCounts = {};

      for (var eval in evaluations) {
        final studentId = eval['student_id'] as String?;
        final score = eval['overall_score'] as int?;

        if (studentId != null && score != null) {
          studentRatings[studentId] = (studentRatings[studentId] ?? 0) + score;
          studentRatingCounts[studentId] =
              (studentRatingCounts[studentId] ?? 0) + 1;
        }
      }

      // Convert totals to averages
      for (var id in studentRatings.keys) {
        final count = studentRatingCounts[id] ?? 1;
        studentRatings[id] = studentRatings[id]! / count;
      }

      return studentsData.map<Student>((json) {
        final Map<String, dynamic> studentJson = Map<String, dynamic>.from(
          json,
        );

        final hasFirstName =
            studentJson['first_name'] != null &&
            studentJson['first_name'].toString().isNotEmpty;
        final hasLastName =
            studentJson['last_name'] != null &&
            studentJson['last_name'].toString().isNotEmpty;

        if (!hasFirstName && !hasLastName) {
          if (bookingNames.containsKey(studentJson['id'])) {
            studentJson['first_name'] = bookingNames[studentJson['id']];
            studentJson['last_name'] = '';
          }
        }

        // Inject calculated average rating
        final studentId = studentJson['id'] as String?;
        if (studentId != null && studentRatings.containsKey(studentId)) {
          studentJson['average_rating'] = studentRatings[studentId];
        }

        return Student.fromJson(studentJson);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
