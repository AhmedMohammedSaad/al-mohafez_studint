import 'session_model.dart';

class SessionsResponseModel {
  final bool success;
  final String message;
  final List<SessionModel> sessions;
  final int totalCount;
  final int upcomingCount;
  final int completedCount;
  final int cancelledCount;

  SessionsResponseModel({
    required this.success,
    required this.message,
    required this.sessions,
    required this.totalCount,
    required this.upcomingCount,
    required this.completedCount,
    required this.cancelledCount,
  });

  factory SessionsResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      sessions: (json['sessions'] as List<dynamic>?)
              ?.map((session) => SessionModel.fromJson(session))
              .toList() ??
          [],
      totalCount: json['total_count'] ?? 0,
      upcomingCount: json['upcoming_count'] ?? 0,
      completedCount: json['completed_count'] ?? 0,
      cancelledCount: json['cancelled_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'total_count': totalCount,
      'upcoming_count': upcomingCount,
      'completed_count': completedCount,
      'cancelled_count': cancelledCount,
    };
  }

  List<SessionModel> get upcomingSessions =>
      sessions.where((session) => session.isUpcoming).toList();

  List<SessionModel> get completedSessions =>
      sessions.where((session) => session.isCompleted).toList();

  List<SessionModel> get ongoingSessions =>
      sessions.where((session) => session.isOngoing).toList();

  List<SessionModel> get cancelledSessions =>
      sessions.where((session) => session.isCancelled).toList();
}