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

      return studentsData.map<Student>((json) {
        // Inject booking name if profile name is empty (handled by StudentModel or manually here)
        // We clone the json to avoid modifying the original map if strictly typed (though likely dynamic)
        final Map<String, dynamic> studentJson = Map<String, dynamic>.from(
          json,
        );

        // If profile first/last names are missing/empty, we can inject 'first_name' using the booking name
        // Or we can let StudentModel handle a 'name' field if we add it back?
        // Actually StudentModel calculates name from first_name + last_name.
        // Let's check what we have.
        final hasFirstName =
            studentJson['first_name'] != null &&
            studentJson['first_name'].toString().isNotEmpty;
        final hasLastName =
            studentJson['last_name'] != null &&
            studentJson['last_name'].toString().isNotEmpty;

        if (!hasFirstName && !hasLastName) {
          // Fallback to booking name
          if (bookingNames.containsKey(studentJson['id'])) {
            // We can hack this by putting the full name in 'first_name'
            // so StudentModel sees it.
            studentJson['first_name'] = bookingNames[studentJson['id']];
            studentJson['last_name'] = '';
          }
        }

        return Student.fromJson(studentJson);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
