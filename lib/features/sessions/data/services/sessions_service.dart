import 'package:easy_localization/easy_localization.dart';
import '../models/session_model.dart';
import '../models/sessions_response_model.dart';
import '../models/session_rating_model.dart';
import '../mock_data/mock_sessions_data.dart';

class SessionsService {
  // Simulate API delay
  static Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Get all sessions for the current student
  static Future<SessionsResponseModel> getAllSessions() async {
    await _simulateDelay();

    try {
      final sessions = MockSessionsData.getMockSessions();

      // Update session statuses based on current time
      final updatedSessions = sessions.map((session) {
        return _updateSessionStatus(session);
      }).toList();

      return SessionsResponseModel(
        success: true,
        message: 'sessions_service_load_success'.tr(),
        sessions: updatedSessions,
        totalCount: updatedSessions.length,
        upcomingCount: updatedSessions.where((s) => s.status == SessionStatus.upcoming).length,
        completedCount: updatedSessions.where((s) => s.status == SessionStatus.completed).length,
        cancelledCount: updatedSessions.where((s) => s.status == SessionStatus.cancelled).length,
      );
    } catch (e) {
      return SessionsResponseModel(
        success: false,
        message: 'sessions_service_load_error'.tr(),
        sessions: [],
        totalCount: 0,
        upcomingCount: 0,
        completedCount: 0,
        cancelledCount: 0,
      );
    }
  }

  // Update session status based on current time
  static SessionModel _updateSessionStatus(SessionModel session) {
    final now = DateTime.now();
    final sessionStart = session.scheduledDateTime;
    final sessionEnd = sessionStart.add(
      Duration(minutes: session.durationMinutes),
    );

    // If session is already completed or cancelled, don't change status
    if (session.status == SessionStatus.completed ||
        session.status == SessionStatus.cancelled) {
      return session;
    }

    SessionStatus newStatus;

    if (now.isBefore(sessionStart)) {
      // Session hasn't started yet
      newStatus = SessionStatus.upcoming;
    } else if (now.isAfter(sessionEnd)) {
      // Session has ended
      newStatus = SessionStatus.completed;
    } else {
      // Session is currently ongoing
      newStatus = SessionStatus.ongoing;
    }

    return SessionModel(
      id: session.id,
      tutorId: session.tutorId,
      tutorName: session.tutorName,
      tutorImageUrl: session.tutorImageUrl,
      studentId: session.studentId,
      type: session.type,
      mode: session.mode,
      scheduledDateTime: session.scheduledDateTime,
      durationMinutes: session.durationMinutes,
      status: newStatus,
      meetingUrl: session.meetingUrl,
      notes: session.notes,
      rating: session.rating,
      feedback: session.feedback,
    );
  }

  // Get upcoming sessions
  static Future<List<SessionModel>> getUpcomingSessions(
    String studentId,
  ) async {
    await _simulateDelay();

    try {
      return MockSessionsData.getUpcomingSessions();
    } catch (e) {
      return [];
    }
  }

  // Get completed sessions
  static Future<List<SessionModel>> getCompletedSessions(
    String studentId,
  ) async {
    await _simulateDelay();

    try {
      return MockSessionsData.getCompletedSessions();
    } catch (e) {
      return [];
    }
  }

  // Get session by ID
  static Future<SessionModel?> getSessionById(String sessionId) async {
    await _simulateDelay();

    try {
      return MockSessionsData.getSessionById(sessionId);
    } catch (e) {
      return null;
    }
  }

  // Join session (update status to ongoing)
  static Future<bool> joinSession(String sessionId) async {
    await _simulateDelay();

    try {
      // In a real app, this would update the session status in the backend
      // and possibly create/join a meeting room
      return true;
    } catch (e) {
      return false;
    }
  }

  // End session (update status to completed)
  static Future<bool> endSession(String sessionId) async {
    await _simulateDelay();

    try {
      // In a real app, this would update the session status
      return true;
    } catch (e) {
      return false;
    }
  }

  // Submit session rating
  static Future<bool> submitSessionRating(SessionRatingModel rating) async {
    await _simulateDelay();

    try {
      // In a real app, this would send the rating to the backend
      return true;
    } catch (e) {
      return false;
    }
  }

  // Cancel session
  static Future<bool> cancelSession(String sessionId, String reason) async {
    await _simulateDelay();

    try {
      // In a real app, this would update the session status and notify the tutor
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if session can be joined (within 10 minutes of start time)
  static bool canJoinSession(SessionModel session) {
    final now = DateTime.now();
    final sessionStart = session.scheduledDateTime;
    final sessionEnd = sessionStart.add(
      Duration(minutes: session.durationMinutes),
    );

    // Can join 10 minutes before start time and during the session
    final canJoinTime = sessionStart.subtract(const Duration(minutes: 10));

    return now.isAfter(canJoinTime) &&
        now.isBefore(sessionEnd) &&
        session.status != SessionStatus.completed &&
        session.status != SessionStatus.cancelled;
  }

  // Get countdown in seconds until session starts
  static int getCountdownSeconds(SessionModel session) {
    final now = DateTime.now();
    final sessionStart = session.scheduledDateTime;
    final difference = sessionStart.difference(now);

    if (difference.isNegative) return 0;
    return difference.inSeconds;
  }

  // Check if session should show countdown (less than 10 minutes to start)
  static bool shouldShowCountdown(SessionModel session) {
    final now = DateTime.now();
    final sessionStart = session.scheduledDateTime;
    final minutesToStart = sessionStart.difference(now).inMinutes;

    return minutesToStart <= 10 && minutesToStart > 0;
  }

  // Get session button state and text
  static Map<String, dynamic> getSessionButtonState(SessionModel session) {
    final now = DateTime.now();
    final sessionStart = session.scheduledDateTime;
    final sessionEnd = sessionStart.add(
      Duration(minutes: session.durationMinutes),
    );
    final minutesToStart = sessionStart.difference(now).inMinutes;

    if (session.status == SessionStatus.cancelled) {
      return {
        'text': 'session_details_cancelled'.tr(),
        'color': 'grey',
        'enabled': false,
        'action': 'none',
      };
    }

    if (session.status == SessionStatus.completed) {
      return {
        'text': session.rating != null ? 'session_service_rated'.tr() : 'session_details_rate'.tr(),
        'color': 'grey',
        'enabled': session.rating == null,
        'action': session.rating == null ? 'rate' : 'none',
      };
    }

    if (now.isAfter(sessionEnd)) {
      return {
        'text': 'session_details_ended'.tr(),
        'color': 'grey',
        'enabled': true,
        'action': 'rate',
      };
    }

    if (now.isAfter(sessionStart)) {
      return {
        'text': 'session_details_join'.tr(),
        'color': 'green',
        'enabled': true,
        'action': 'join',
      };
    }

    if (minutesToStart <= 10) {
      return {
        'text': 'session_details_join'.tr(),
        'color': 'green',
        'enabled': true,
        'action': 'join',
      };
    }

    return {
      'text': 'session_details_not_started'.tr(),
      'color': 'grey',
      'enabled': false,
      'action': 'none',
    };
  }

  // Check if notification should be sent (15 minutes before session)
  static bool shouldSendNotification(SessionModel session) {
    final now = DateTime.now();
    final sessionStart = session.scheduledDateTime;
    final minutesToStart = sessionStart.difference(now).inMinutes;

    return minutesToStart == 15 && session.status == SessionStatus.upcoming;
  }

  // Get notification message
  static String getNotificationMessage(SessionModel session) {
    return 'session_service_notification'.tr(namedArgs: {
      'tutorName': session.tutorName,
      'time': _formatTime(session.scheduledDateTime)
    });
  }

  // Format time for display
  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'session_service_pm'.tr() : 'session_service_am'.tr();
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute$period';
  }

  // Get sessions that need status update
  static List<SessionModel> getSessionsNeedingUpdate(
    List<SessionModel> sessions,
  ) {
    final now = DateTime.now();

    return sessions.where((session) {
      final sessionStart = session.scheduledDateTime;
      final sessionEnd = sessionStart.add(
        Duration(minutes: session.durationMinutes),
      );

      // Check if status needs to be updated
      if (session.status == SessionStatus.upcoming &&
          now.isAfter(sessionStart)) {
        return true;
      }

      if (session.status == SessionStatus.ongoing && now.isAfter(sessionEnd)) {
        return true;
      }

      return false;
    }).toList();
  }

  // Send notification reminder
  static Future<bool> sendSessionReminder(String sessionId) async {
    await _simulateDelay();

    try {
      // In a real app, this would trigger a push notification
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get session statistics
  static Future<Map<String, int>> getSessionStatistics(String studentId) async {
    await _simulateDelay();

    try {
      final sessions = MockSessionsData.getMockSessions();

      return {
        'total': sessions.length,
        'upcoming': sessions
            .where((s) => s.status == SessionStatus.upcoming)
            .length,
        'completed': sessions
            .where((s) => s.status == SessionStatus.completed)
            .length,
        'cancelled': sessions
            .where((s) => s.status == SessionStatus.cancelled)
            .length,
        'this_week': sessions.where((s) {
          final now = DateTime.now();
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(Duration(days: 7));
          return s.scheduledDateTime.isAfter(weekStart) &&
              s.scheduledDateTime.isBefore(weekEnd);
        }).length,
      };
    } catch (e) {
      return {
        'total': 0,
        'upcoming': 0,
        'completed': 0,
        'cancelled': 0,
        'this_week': 0,
      };
    }
  }

  // Auto-update session statuses periodically
  static Future<void> autoUpdateSessionStatuses() async {
    // This would be called periodically by a background service
    // For now, it's just a placeholder for the concept
    try {
      final response = await getAllSessions();
      if (response.success) {
        final sessionsNeedingUpdate = getSessionsNeedingUpdate(
          response.sessions,
        );

        for (final session in sessionsNeedingUpdate) {
          // In a real app, this would update the backend
          print('Session ${session.id} status updated to ${session.status}');
        }
      }
    } catch (e) {
      print('Error auto-updating session statuses: $e');
    }
  }
}
