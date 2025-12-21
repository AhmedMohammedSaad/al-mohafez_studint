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
}
