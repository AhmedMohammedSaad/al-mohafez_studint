import '../../data/models/teacher_profile_model.dart';

abstract class TeacherProfileState {}

class TeacherProfileInitial extends TeacherProfileState {}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileLoaded extends TeacherProfileState {
  final TeacherProfileModel profile;

  TeacherProfileLoaded(this.profile);
}

class TeacherProfileError extends TeacherProfileState {
  final String message;

  TeacherProfileError(this.message);
}

class TeacherProfileUpdating extends TeacherProfileState {}

class TeacherProfileUpdateSuccess extends TeacherProfileState {
  final String message;

  TeacherProfileUpdateSuccess(this.message);
}

class TeacherProfileLoggedOut extends TeacherProfileState {}
