import '../models/session_model.dart';
import '../models/sessions_response_model.dart';

class MockSessionsData {
  static List<SessionModel> getMockSessions() {
    final now = DateTime.now();
    
    return [
      // Upcoming sessions
      SessionModel(
        id: 'session_1',
        tutorId: 'tutor_1',
        tutorName: 'الشيخ أحمد محمد',
        tutorImageUrl: 'assets/images/tutor_1.jpg',
        studentId: 'student_1',
        type: SessionType.recitation,
        mode: SessionMode.online,
        scheduledDateTime: now.add(Duration(hours: 2)),
        durationMinutes: 45,
        status: SessionStatus.upcoming,
        meetingUrl: 'https://meet.google.com/abc-defg-hij',
        notes: 'مراجعة سورة البقرة من الآية 1 إلى 20',
      ),
      
      SessionModel(
        id: 'session_2',
        tutorId: 'tutor_2',
        tutorName: 'الشيخ محمد علي',
        tutorImageUrl: 'assets/images/tutor_2.jpg',
        studentId: 'student_1',
        type: SessionType.tajweed,
        mode: SessionMode.online,
        scheduledDateTime: now.add(Duration(minutes: 5)), // Soon to start
        durationMinutes: 60,
        status: SessionStatus.upcoming,
        meetingUrl: 'https://zoom.us/j/123456789',
        notes: 'درس في أحكام النون الساكنة والتنوين',
      ),
      
      SessionModel(
        id: 'session_3',
        tutorId: 'tutor_3',
        tutorName: 'الشيخ عبدالله حسن',
        tutorImageUrl: 'assets/images/tutor_3.jpg',
        studentId: 'student_1',
        type: SessionType.memorization,
        mode: SessionMode.inPerson,
        scheduledDateTime: now.add(Duration(days: 1)),
        durationMinutes: 45,
        status: SessionStatus.upcoming,
        notes: 'حفظ سورة الكهف',
      ),
      
      // Ongoing session
      SessionModel(
        id: 'session_4',
        tutorId: 'tutor_1',
        tutorName: 'الشيخ أحمد محمد',
        tutorImageUrl: 'assets/images/tutor_1.jpg',
        studentId: 'student_1',
        type: SessionType.review,
        mode: SessionMode.online,
        scheduledDateTime: now.subtract(Duration(minutes: 10)),
        durationMinutes: 45,
        status: SessionStatus.ongoing,
        meetingUrl: 'https://meet.google.com/xyz-uvw-rst',
        actualStartTime: now.subtract(Duration(minutes: 10)),
        notes: 'مراجعة الحفظ السابق',
      ),
      
      // Completed sessions
      SessionModel(
        id: 'session_5',
        tutorId: 'tutor_2',
        tutorName: 'الشيخ محمد علي',
        tutorImageUrl: 'assets/images/tutor_2.jpg',
        studentId: 'student_1',
        type: SessionType.recitation,
        mode: SessionMode.online,
        scheduledDateTime: now.subtract(Duration(days: 1)),
        durationMinutes: 45,
        status: SessionStatus.completed,
        actualStartTime: now.subtract(Duration(days: 1)),
        actualEndTime: now.subtract(Duration(days: 1)).add(Duration(minutes: 45)),
        rating: 4.5,
        feedback: 'جلسة ممتازة، الشيخ واضح ومفيد',
        tutorNotes: 'الطالب متفاعل ويحفظ بشكل جيد',
      ),
      
      SessionModel(
        id: 'session_6',
        tutorId: 'tutor_3',
        tutorName: 'الشيخ عبدالله حسن',
        tutorImageUrl: 'assets/images/tutor_3.jpg',
        studentId: 'student_1',
        type: SessionType.tajweed,
        mode: SessionMode.online,
        scheduledDateTime: now.subtract(Duration(days: 2)),
        durationMinutes: 60,
        status: SessionStatus.completed,
        actualStartTime: now.subtract(Duration(days: 2)),
        actualEndTime: now.subtract(Duration(days: 2)).add(Duration(minutes: 60)),
        rating: 5.0,
        feedback: 'شرح ممتاز للأحكام',
        tutorNotes: 'يحتاج المزيد من التدريب على المدود',
      ),
      
      SessionModel(
        id: 'session_7',
        tutorId: 'tutor_1',
        tutorName: 'الشيخ أحمد محمد',
        tutorImageUrl: 'assets/images/tutor_1.jpg',
        studentId: 'student_1',
        type: SessionType.memorization,
        mode: SessionMode.inPerson,
        scheduledDateTime: now.subtract(Duration(days: 3)),
        durationMinutes: 45,
        status: SessionStatus.completed,
        actualStartTime: now.subtract(Duration(days: 3)),
        actualEndTime: now.subtract(Duration(days: 3)).add(Duration(minutes: 45)),
        rating: 4.0,
        feedback: 'جلسة جيدة',
        tutorNotes: 'حفظ جيد، يحتاج مراجعة دورية',
      ),
      
      // Cancelled session
      SessionModel(
        id: 'session_8',
        tutorId: 'tutor_2',
        tutorName: 'الشيخ محمد علي',
        tutorImageUrl: 'assets/images/tutor_2.jpg',
        studentId: 'student_1',
        type: SessionType.review,
        mode: SessionMode.online,
        scheduledDateTime: now.subtract(Duration(days: 4)),
        durationMinutes: 45,
        status: SessionStatus.cancelled,
        notes: 'تم الإلغاء بسبب ظروف طارئة',
      ),
    ];
  }
  
  static SessionsResponseModel getMockSessionsResponse() {
    final sessions = getMockSessions();
    
    return SessionsResponseModel(
      success: true,
      message: 'تم جلب الجلسات بنجاح',
      sessions: sessions,
      totalCount: sessions.length,
      upcomingCount: sessions.where((s) => s.isUpcoming).length,
      completedCount: sessions.where((s) => s.isCompleted).length,
      cancelledCount: sessions.where((s) => s.isCancelled).length,
    );
  }
  
  static List<SessionModel> getUpcomingSessions() {
    return getMockSessions().where((session) => session.isUpcoming).toList()
      ..sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));
  }
  
  static List<SessionModel> getCompletedSessions() {
    return getMockSessions().where((session) => session.isCompleted).toList()
      ..sort((a, b) => b.scheduledDateTime.compareTo(a.scheduledDateTime));
  }
  
  static List<SessionModel> getOngoingSessions() {
    return getMockSessions().where((session) => session.isOngoing).toList();
  }
  
  static SessionModel? getSessionById(String id) {
    try {
      return getMockSessions().firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }
}