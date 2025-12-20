import '../../data/models/student_model.dart';

abstract class TeacherStudentsState {}

class TeacherStudentsInitial extends TeacherStudentsState {}

class TeacherStudentsLoading extends TeacherStudentsState {}

class TeacherStudentsLoaded extends TeacherStudentsState {
  final List<Student> students;

  TeacherStudentsLoaded(this.students);
}

class TeacherStudentsError extends TeacherStudentsState {
  final String message;

  TeacherStudentsError(this.message);
}
