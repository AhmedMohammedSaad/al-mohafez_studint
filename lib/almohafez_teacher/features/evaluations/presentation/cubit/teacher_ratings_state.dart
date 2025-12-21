import 'package:almohafez/almohafez_teacher/features/evaluations/data/models/teacher_rating_model.dart';

abstract class TeacherRatingsState {}

class TeacherRatingsInitial extends TeacherRatingsState {}

class TeacherRatingsLoading extends TeacherRatingsState {}

class TeacherRatingsLoaded extends TeacherRatingsState {
  final List<TeacherRating> ratings;
  final double averageRating;

  TeacherRatingsLoaded(this.ratings, this.averageRating);
}

class TeacherRatingsError extends TeacherRatingsState {
  final String message;

  TeacherRatingsError(this.message);
}
