import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ProfileModel> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      // Fetch profile data from 'profiles' table
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      // Merge with auth data (email)
      final profileData = Map<String, dynamic>.from(data);
      profileData['email'] = user.email;
      // Try to get phone from meta if not in table, or vice versa
      if (profileData['phone'] == null) {
        profileData['phone'] = user.phone;
      }

      // --- FETCH STATISTICS ---
      // 1. Fetch Evaluations to calculate Average Score
      try {
        final evalResponse = await _supabase
            .from('session_evaluations')
            .select('overall_score')
            .eq('student_id', user.id);

        final evaluations = evalResponse as List;
        if (evaluations.isNotEmpty) {
          final totalScore = evaluations.fold<double>(
            0,
            (sum, item) => sum + (item['overall_score'] as num),
          );

          // Calculate average out of 100? or out of 5?
          // The score is usually out of 5. User wants a Percentage Rate probably.
          // In ProgressRepo: (rating / 5.0) * 100
          // Let's store the raw average percentage.
          final avgRating = totalScore / evaluations.length;
          final percentage = (avgRating / 5.0) * 100;
          profileData['average_score'] = percentage;
        } else {
          profileData['average_score'] = 0.0;
        }
      } catch (e) {
        print('Error fetching evaluations for profile: $e');
        profileData['average_score'] = 0.0;
      }

      // 2. Fetch Sessions Count (Completed sessions)
      // User said "Sessions wants integrated with sessions he has".
      // We can count all bookings that are 'completed' OR have an evaluation.
      try {
        // We can just count total bookings for now or completed ones.
        // Let's count COMPLETED bookings as that's usually deeper "sessions".
        // Or just ALL bookings? User said "Sessions". Let's assume completed for now to match progress.
        // Actually, let's just count all bookings to be safe? Or completed.
        // Let's stick to "Completed" as it implies "Attended sessions".
        // Note: count is returned directly if using count() modifier, but here with select?
        // Let's use select with count.
        // Supabase Flutter v2: count is usually returned if requested.
        // Actually .count() returns int Future.

        // Let's try simpler query list and .length if count not easy without looking up docs version.
        // But count() is efficient.
        // .count(CountOption.exact) returns Future<int> in recent versions.

        // Wait, select().count() returns PostgrestResponse in some versions.
        // Let's just fetch simplified list id to be safe on api version.
        final bookingsList = await _supabase
            .from('bookings')
            .select('id')
            .eq('student_id', user.id)
            .eq('status', 'completed');

        profileData['total_sessions'] = (bookingsList as List).length;
      } catch (e) {
        print('Error fetching bookings count for profile: $e');
        profileData['total_sessions'] = 0;
      }

      return ProfileModel.fromJson(profileData);
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } on AuthException catch (e) {
      throw Exception('Auth Error: ${e.message}');
    } catch (e) {
      // If profile doesn't exist, return basic info from auth
      print('Profile fetch error (using fallback): $e');
      return ProfileModel(
        id: user.id,
        firstName: user.userMetadata?['first_name'] ?? '',
        lastName: user.userMetadata?['last_name'] ?? '',
        email: user.email ?? '',
        phoneNumber: user.phone,
        avatarUrl: user.userMetadata?['avatar_url'],
      );
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final updates = <String, dynamic>{
        'id': user.id,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      // We store phone in profile table too for easy access
      if (phoneNumber != null) updates['phone'] = phoneNumber;
      // if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _supabase.from('profiles').upsert(updates);

      // Also update auth metadata to keep them in sync
      await _supabase.auth.updateUser(
        UserAttributes(
          phone: phoneNumber,
          data: {
            if (firstName != null) 'first_name': firstName,
            if (lastName != null) 'last_name': lastName,
            // if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );
    } catch (e) {
      throw Exception('Database Error: ${e.toString()}');
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception('Auth Error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Auth Error: ${e.toString()}');
    }
  }

  Future<void> deleteAccount() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        // Delete profile data
        await _supabase.from('profiles').delete().eq('id', user.id);
      } catch (e) {
        // Ignore error if profile deletion fails, still proceed to sign out
        print('Error deleting profile: $e');
      }
      // Sign out
      await _supabase.auth.signOut();
    }
  }
}
