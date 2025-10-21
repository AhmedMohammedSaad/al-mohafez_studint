import 'package:easy_localization/easy_localization.dart';
import '../models/progress_model.dart';

class ProgressMockData {
  static ProgressModel getSampleData() {
    return ProgressModel(
      overallProgress: 65.0,
      dailyPerformance: [
        DailyPerformance(date: '2024-01-15', percentage: 45.0, dayName: 'progress_day_monday'.tr()),
        DailyPerformance(date: '2024-01-16', percentage: 60.0, dayName: 'progress_day_tuesday'.tr()),
        DailyPerformance(date: '2024-01-17', percentage: 75.0, dayName: 'progress_day_wednesday'.tr()),
        DailyPerformance(date: '2024-01-18', percentage: 65.0, dayName: 'progress_day_thursday'.tr()),
        DailyPerformance(date: '2024-01-19', percentage: 80.0, dayName: 'progress_day_friday'.tr()),
        DailyPerformance(date: '2024-01-20', percentage: 70.0, dayName: 'progress_day_saturday'.tr()),
        DailyPerformance(date: '2024-01-21', percentage: 85.0, dayName: 'progress_day_sunday'.tr()),
        DailyPerformance(date: '2024-01-22', percentage: 90.0, dayName: 'progress_day_monday'.tr()),
        DailyPerformance(date: '2024-01-23', percentage: 55.0, dayName: 'progress_day_tuesday'.tr()),
        DailyPerformance(date: '2024-01-24', percentage: 95.0, dayName: 'progress_day_wednesday'.tr()),
        DailyPerformance(date: '2024-01-25', percentage: 78.0, dayName: 'progress_day_thursday'.tr()),
        DailyPerformance(date: '2024-01-26', percentage: 88.0, dayName: 'progress_day_friday'.tr()),
        DailyPerformance(date: '2024-01-27', percentage: 72.0, dayName: 'progress_day_saturday'.tr()),
        DailyPerformance(date: '2024-01-28', percentage: 92.0, dayName: 'progress_day_sunday'.tr()),
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