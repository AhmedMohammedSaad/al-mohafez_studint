import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class TeacherAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String qualifications,
    required String gender,
    required Map<String, dynamic> availability,
    File? profileImage,
  }) async {
    try {
      // 1. Sign up with Supabase Auth
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'role': 'teacher', // Mark as teacher in metadata
        },
      );

      if (response.user == null) {
        throw const AuthException(
          'Sign up failed: User creation returned null',
        );
      }

      final String userId = response.user!.id;
      String? imageUrl;

      // 2. Upload Profile Image if provided
      if (profileImage != null) {
        try {
          final String fileExt = path.extension(profileImage.path);
          final String fileName = '$userId/profile$fileExt';

          await _supabase.storage
              .from('images')
              .upload(
                fileName,
                profileImage,
                fileOptions: const FileOptions(upsert: true),
              );

          imageUrl = _supabase.storage.from('images').getPublicUrl(fileName);
        } catch (e) {
          // Log error but continue with sign up
          print('Error uploading image: $e');
        }
      }

      // 3. Insert into teachers table
      final teacherData = {
        'id': userId, // Link to auth.users
        'full_name': '$firstName $lastName',
        'email': email,
        'phone': phone,
        'profile_picture_url': imageUrl ?? '',
        'qualifications': [qualifications],
        'availability_slots': _formatAvailability(availability),
        'is_available': true,
        'overall_rating': 5.0, // Default as per schema
        'num_sessions': 0,
        'bio': qualifications, // Use qualifications as initial bio
        'gender': gender,
        'session_price': 50.0, // Default price
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('teachers').insert(teacherData);

      return response;
    } catch (e) {
      // If anything fails after auth signup, we should probably cleanup the auth user
      // But for now, just rethrow
      print('Error signing up teacher: $e');
      rethrow;
    }
  }

  List<Map<String, String>> _formatAvailability(
    Map<String, dynamic> availability,
  ) {
    List<Map<String, String>> slots = [];
    availability.forEach((day, times) {
      if (times is Map && times['start'] != null && times['end'] != null) {
        slots.add({
          'day': day,
          'start': _formatTimeOfDay(times['start']),
          'end': _formatTimeOfDay(times['end']),
        });
      }
    });
    return slots;
  }

  String _formatTimeOfDay(dynamic time) {
    if (time == null) return '';
    // Assuming time is TimeOfDay or similar
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
