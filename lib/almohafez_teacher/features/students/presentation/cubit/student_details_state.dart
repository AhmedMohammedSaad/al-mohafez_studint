abstract class StudentDetailsState {}

class StudentDetailsInitial extends StudentDetailsState {}

class StudentDetailsLoading extends StudentDetailsState {}

class StudentDetailsLoaded extends StudentDetailsState {
  final List<Map<String, dynamic>> bookings;
  final Map<String, dynamic> stats;

  StudentDetailsLoaded(this.bookings, this.stats);
}

class StudentDetailsError extends StudentDetailsState {
  final String message;

  StudentDetailsError(this.message);
}
