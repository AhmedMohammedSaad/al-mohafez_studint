import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/teacher_ratings_repo.dart';
import 'teacher_ratings_state.dart';

class TeacherRatingsCubit extends Cubit<TeacherRatingsState> {
  final TeacherRatingsRepo _repo;

  TeacherRatingsCubit(this._repo) : super(TeacherRatingsInitial());

  Future<void> loadRatings() async {
    emit(TeacherRatingsLoading());
    try {
      final ratings = await _repo.getTeacherRatings();
      final average = await _repo.getAverageRating();
      emit(TeacherRatingsLoaded(ratings, average));
    } catch (e) {
      emit(TeacherRatingsError(e.toString()));
    }
  }
}
