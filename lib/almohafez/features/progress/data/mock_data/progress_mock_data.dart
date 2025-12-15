import 'package:easy_localization/easy_localization.dart';
import '../models/progress_model.dart';

class ProgressMockData {
  static ProgressModel getSampleData() {
    return ProgressModel(
      overallProgress: 65.0,
      dailyPerformance: [
        // Week 1
        DailyPerformance(date: '2024-01-15', percentage: 75.0, dayName: 'اليوم 1'),
        DailyPerformance(date: '2024-01-18', percentage: 82.0, dayName: 'اليوم 2'),
        // Week 2
        DailyPerformance(date: '2024-01-22', percentage: 68.0, dayName: 'اليوم 1'),
        DailyPerformance(date: '2024-01-25', percentage: 90.0, dayName: 'اليوم 2'),
        // Week 3
        DailyPerformance(date: '2024-01-29', percentage: 85.0, dayName: 'اليوم 1'),
        DailyPerformance(date: '2024-02-01', percentage: 78.0, dayName: 'اليوم 2'),
        // Week 4
        DailyPerformance(date: '2024-02-05', percentage: 92.0, dayName: 'اليوم 1'),
        DailyPerformance(date: '2024-02-08', percentage: 88.0, dayName: 'اليوم 2'),
      ],
      recentSessions: [
        RecentSession(
          date: '2025-01-15',
          teacherName: 'الشيخ أحمد محمود',
          rating: 4,
          maxRating: 5,
        ),
        RecentSession(
          date: '2025-01-12',
          teacherName: 'الشيخ محمد علي',
          rating: 5,
          maxRating: 5,
        ),
        RecentSession(
          date: '2025-01-10',
          teacherName: 'الشيخ أحمد محمود',
          rating: 3,
          maxRating: 5,
        ),
        RecentSession(
          date: '2025-01-08',
          teacherName: 'الشيخ عبدالرحمن',
          rating: 4,
          maxRating: 5,
        ),
      ],
      teacherNotes: [
        TeacherNote(
          note: 'أداء ممتاز هذا الأسبوع 👏',
          timestamp: '2025-01-15',
        ),
        TeacherNote(
          note: 'تحسن ملحوظ في التجويد',
          timestamp: '2025-01-12',
        ),
        TeacherNote(
          note: 'يحتاج إلى مراجعة الآيات السابقة',
          timestamp: '2025-01-10',
        ),
        TeacherNote(
          note: 'استمر على هذا المستوى الرائع',
          timestamp: '2025-01-08',
        ),
      ],
    );
  }

  static ProgressModel getEmptyData() {
    return ProgressModel(
      overallProgress: 0.0,
      dailyPerformance: [],
      recentSessions: [],
      teacherNotes: [],
    );
  }

  static ProgressModel getErrorData() {
    return ProgressModel(
      overallProgress: 0.0,
      dailyPerformance: [],
      recentSessions: [],
      teacherNotes: [],
      hasError: true,
      errorMessage: 'progress_loading_error'.tr(),
    );
  }
}