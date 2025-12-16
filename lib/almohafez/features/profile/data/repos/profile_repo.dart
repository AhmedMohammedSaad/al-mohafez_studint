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
