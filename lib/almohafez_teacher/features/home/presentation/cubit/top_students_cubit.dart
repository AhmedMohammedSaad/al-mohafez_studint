import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/top_students_repo.dart';
import 'top_students_state.dart';

class TopStudentsCubit extends Cubit<TopStudentsState> {
  final TopStudentsRepo _repo;

  TopStudentsCubit(this._repo) : super(TopStudentsInitial());

  Future<void> loadTopStudents() async {
    emit(TopStudentsLoading());
    try {
      final students = await _repo.getTopStudents();
      emit(TopStudentsLoaded(students));
    } catch (e) {
      emit(TopStudentsError(e.toString()));
    }
  }

  Future<void> updateProgress(String id, double progress) async {
    final success = await _repo.updateStudentProgress(id, progress);
    if (success) {
      await loadTopStudents(); // Refresh the list
    }
  }

  Future<void> addStudent({
    required String studentId,
    required String name,
    required double progress,
  }) async {
    final result = await _repo.addTopStudent(
      studentId: studentId,
      name: name,
      progress: progress,
    );
    if (result != null) {
      await loadTopStudents(); // Refresh the list
    }
  }

  Future<void> removeStudent(String id) async {
    final success = await _repo.deleteTopStudent(id);
    if (success) {
      await loadTopStudents(); // Refresh the list
    }
  }
}
