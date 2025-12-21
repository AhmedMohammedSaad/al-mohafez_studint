import '../../data/models/top_student_model.dart';

abstract class TopStudentsState {}

class TopStudentsInitial extends TopStudentsState {}

class TopStudentsLoading extends TopStudentsState {}

class TopStudentsLoaded extends TopStudentsState {
  final List<TopStudent> students;

  TopStudentsLoaded(this.students);
}

class TopStudentsError extends TopStudentsState {
  final String message;

  TopStudentsError(this.message);
}
