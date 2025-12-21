import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/student_details_repo.dart';
import 'student_details_state.dart';

class StudentDetailsCubit extends Cubit<StudentDetailsState> {
  final StudentDetailsRepo _repo;

  StudentDetailsCubit(this._repo) : super(StudentDetailsInitial());

  Future<void> loadStudentDetails(String studentId) async {
    emit(StudentDetailsLoading());
    try {
      final bookings = await _repo.getStudentBookings(studentId);
      final stats = await _repo.getStudentStats(studentId);
      final evaluations = await _repo.getStudentEvaluations(studentId);
      final averageRating = _repo.calculateAverageRating(evaluations);

      emit(StudentDetailsLoaded(bookings, stats, evaluations, averageRating));
    } catch (e) {
      emit(StudentDetailsError(e.toString()));
    }
  }
}
