import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/teacher_profile_repo.dart';
import '../../data/models/teacher_profile_model.dart';
import 'teacher_profile_state.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final TeacherProfileRepo _repo;

  TeacherProfileCubit(this._repo) : super(TeacherProfileInitial());

  Future<void> loadProfile() async {
    // Check if user is logged in before emitting loading
    // We can check Supabase.instance.client.auth.currentSession or catch the specific error
    // But since the Repo throws "User not logged in", we can catch that specifically or check here.
    // However, Repo check is cleaner for data integrity.
    // Let's just catch the specific error and emit Initial or LoggedOut instead of Error

    emit(TeacherProfileLoading());
    try {
      final profile = await _repo.getProfile();
      emit(TeacherProfileLoaded(profile));
    } catch (e) {
      if (e.toString().contains('User not logged in')) {
        // Should ideally be TeacherProfileLoggedOut or Initial, but LoggedOut might trigger navigation loop if not careful.
        // If we are just starting, maybe Initial is better, or a specific "Guest" state.
        // For now, let's just return to Initial or emit an empty state that doesn't show error snackbar.
        emit(TeacherProfileInitial());
      } else {
        emit(TeacherProfileError(e.toString()));
      }
    }
  }

  Future<void> updateProfile(TeacherProfileModel profile) async {
    emit(TeacherProfileUpdating());
    try {
      await _repo.updateProfile(profile);
      emit(TeacherProfileUpdateSuccess('Profile updated successfully'));
      // Reload profile to get latest data
      await loadProfile();
    } catch (e) {
      emit(TeacherProfileError(e.toString()));
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    emit(TeacherProfileUpdating());
    try {
      await _repo.uploadProfileImage(imageFile);
      emit(TeacherProfileUpdateSuccess('Profile image updated successfully'));
      await loadProfile();
    } catch (e) {
      emit(TeacherProfileError(e.toString()));
    }
  }

  Future<void> changePassword(String newPassword) async {
    emit(TeacherProfileUpdating());
    try {
      await _repo.changePassword(newPassword);
      emit(TeacherProfileUpdateSuccess('password_changed_success'));
      // Reload profile to restore loaded state
      final profile = await _repo.getProfile();
      emit(TeacherProfileLoaded(profile));
    } catch (e) {
      emit(TeacherProfileError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _repo.logout();
      emit(TeacherProfileLoggedOut());
    } catch (e) {
      emit(TeacherProfileError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(TeacherProfileUpdating());
    try {
      await _repo.deleteAccount();
      emit(TeacherProfileLoggedOut());
    } catch (e) {
      emit(TeacherProfileError(e.toString()));
    }
  }
}
