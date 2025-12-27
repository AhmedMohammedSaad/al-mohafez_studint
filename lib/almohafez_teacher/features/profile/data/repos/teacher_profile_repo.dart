import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import '../models/teacher_profile_model.dart';

class TeacherProfileRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<TeacherProfileModel> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userId = user.id;
    final data = await _supabase
        .from('teachers')
        .select()
        .eq('id', userId)
        .single();
    return TeacherProfileModel.fromJson(data);
  }

  Future<void> updateProfile(TeacherProfileModel profile) async {
    await _supabase
        .from('teachers')
        .update({
          'full_name': profile.fullName,
          'email': profile.email,
          'phone': profile.phone,
          'bio': profile.bio,
          'gender': profile.gender,
          'availability_slots': profile.availabilitySlots
              .map((e) => e.toJson())
              .toList(),
        })
        .eq('id', profile.id);
  }

  Future<String> uploadProfileImage(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userId = user.id;
    final fileExt = path.extension(imageFile.path);
    final fileName =
        '$userId/profile${DateTime.now().millisecondsSinceEpoch}$fileExt';

    await _supabase.storage
        .from('images')
        .upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final imageUrl = _supabase.storage.from('images').getPublicUrl(fileName);

    // Update profile with new image URL
    await _supabase
        .from('teachers')
        .update({'profile_picture_url': imageUrl})
        .eq('id', userId);

    return imageUrl;
  }

  Future<void> changePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      // Already logged out or invalid state, just sign out to be safe
      await _supabase.auth.signOut();
      return;
    }
    final userId = user.id;
    // Delete teacher profile data
    await _supabase.from('teachers').delete().eq('id', userId);
    // Note: Deleting the actual Auth user usually requires admin privileges or an Edge Function.
    // For now, we delete the profile data and sign out.
    await _supabase.auth.signOut();
  }
}
