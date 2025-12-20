import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/teacher_students_repo.dart';
import 'teacher_students_state.dart';

class TeacherStudentsCubit extends Cubit<TeacherStudentsState> {
  final TeacherStudentsRepo _repo;

  TeacherStudentsCubit(this._repo) : super(TeacherStudentsInitial());

  Future<void> loadStudents() async {
    emit(TeacherStudentsLoading());
    try {
      final students = await _repo.getStudents();
      emit(TeacherStudentsLoaded(students));
    } catch (e) {
      emit(TeacherStudentsError(e.toString()));
    }
  }
}
