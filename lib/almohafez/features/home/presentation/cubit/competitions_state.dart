import '../../data/models/competition_model.dart';

abstract class CompetitionsState {}

class CompetitionsInitial extends CompetitionsState {}

class CompetitionsLoading extends CompetitionsState {}

class CompetitionsLoaded extends CompetitionsState {
  final Competition? competition;

  CompetitionsLoaded(this.competition);
}

class CompetitionsError extends CompetitionsState {
  final String message;

  CompetitionsError(this.message);
}
