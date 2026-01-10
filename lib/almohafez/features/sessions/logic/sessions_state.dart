import '../data/models/session_model.dart';

abstract class SessionsState {}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<SessionModel> upcomingSessions;
  final List<SessionModel> completedSessions;

  SessionsLoaded({
    required this.upcomingSessions,
    required this.completedSessions,
  });
}

class SessionsError extends SessionsState {
  final String message;

  SessionsError(this.message);
}

class SubscriptionExpired extends SessionsState {}
