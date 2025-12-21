import '../../../sessions/data/models/session_evaluation_model.dart';

abstract class StudentDetailsState {}

class StudentDetailsInitial extends StudentDetailsState {}

class StudentDetailsLoading extends StudentDetailsState {}

class StudentDetailsLoaded extends StudentDetailsState {
  final List<Map<String, dynamic>> bookings;
  final Map<String, dynamic> stats;
  final List<SessionEvaluation> evaluations;
  final double averageRating;

  StudentDetailsLoaded(
    this.bookings,
    this.stats,
    this.evaluations,
    this.averageRating,
  );
}

class StudentDetailsError extends StudentDetailsState {
  final String message;

  StudentDetailsError(this.message);
}
