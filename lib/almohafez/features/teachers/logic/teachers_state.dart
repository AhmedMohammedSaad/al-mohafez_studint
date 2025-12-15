import '../data/models/tutor_model.dart';

abstract class TeachersState {}

class TeachersInitial extends TeachersState {}

class TeachersLoading extends TeachersState {}

class TeachersLoaded extends TeachersState {
  final List<TutorModel> teachers;

  TeachersLoaded(this.teachers);
}

class TeachersError extends TeachersState {
  final String message;

  TeachersError(this.message);
}
