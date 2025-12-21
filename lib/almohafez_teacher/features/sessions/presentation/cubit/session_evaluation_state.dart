import '../../data/models/session_evaluation_model.dart';

abstract class SessionEvaluationState {}

class SessionEvaluationInitial extends SessionEvaluationState {}

class SessionEvaluationLoading extends SessionEvaluationState {}

class SessionEvaluationLoaded extends SessionEvaluationState {
  final SessionEvaluation? evaluation;

  SessionEvaluationLoaded(this.evaluation);
}

class SessionEvaluationSaving extends SessionEvaluationState {}

class SessionEvaluationSaved extends SessionEvaluationState {}

class SessionEvaluationError extends SessionEvaluationState {
  final String message;

  SessionEvaluationError(this.message);
}
