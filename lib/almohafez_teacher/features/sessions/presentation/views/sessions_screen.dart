import 'package:almohafez/almohafez_teacher/features/sessions/presentation/widgets/daily_sessions_widget.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/widgets/session_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/models/session_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  DateTime selectedDate = DateTime.now();

  // Dummy data for sessions
  final List<Session> sessions = [
    Session(
      id: '1',
      studentId: '1',
      studentName: 'أحمد محمد',
      scheduledDate: DateTime.now(),
      duration: const Duration(minutes: 60),
      type: SessionType.review,
      status: SessionStatus.scheduled,
      notes: 'مراجعة سورة البقرة',
      topic: 'سورة البقرة - الآيات 1-20',
    ),
    Session(
      id: '2',
      studentId: '2',
      studentName: 'فاطمة علي',
      scheduledDate: DateTime.now().add(const Duration(hours: 2)),
      duration: const Duration(minutes: 45),
      type: SessionType.memorization,
      status: SessionStatus.scheduled,
      notes: 'تحفيظ جديد',
      topic: 'سورة آل عمران - الآيات 1-10',
    ),
    Session(
      id: '3',
      studentId: '3',
      studentName: 'محمد أحمد',
      scheduledDate: DateTime.now().subtract(const Duration(hours: 1)),
      duration: const Duration(minutes: 60),
      type: SessionType.review,
      status: SessionStatus.completed,
      notes: 'جلسة ممتازة',
      topic: 'سورة النساء - مراجعة',
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      endTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  List<Session> get todaySessions {
    final today = DateTime.now();
    return sessions.where((session) {
      return session.scheduledDate.year == today.year &&
          session.scheduledDate.month == today.month &&
          session.scheduledDate.day == today.day;
    }).toList();
  }

  List<Session> get selectedDateSessions {
    return sessions.where((session) {
      return session.scheduledDate.year == selectedDate.year &&
          session.scheduledDate.month == selectedDate.month &&
          session.scheduledDate.day == selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'إدارة الجلسات',
          style: AppTextStyle.textStyle20Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheet(
                backgroundColor: AppColors.white,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                context: context,
                builder: (context) => Container(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      10.height,
                      Text(
                        'إحصائيات الجلسات',
                        style: AppTextStyle.textStyle20Bold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SessionStatsWidget(sessions: sessions),
                      10.height,
                      // SessionStatsWidget(sessions: sessions),
                    ],
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.bar_chart,
              color: AppColors.textPrimary,
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Statistics
            // SessionStatsWidget(sessions: sessions),
            // SizedBox(height: 20.h),

            // Calendar Widget
            // SessionsCalendarWidget(
            // selectedDate: selectedDate,
            // sessions: sessions,
            // onDateSelected: (date) {
            // setState(() {
            // selectedDate = date;
            // });
            // },
            // ),
            // SizedBox(height: 20.h),

            // Daily Sessions
            DailySessionsWidget(
              selectedDate: selectedDate,
              sessions: selectedDateSessions,
              onSessionTap: (session) {
                // Navigate to session details or start session
                _handleSessionTap(session);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSessionTap(Session session) {
    if (session.status == SessionStatus.scheduled) {
      // Show options to start session or edit
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text('خيارات الجلسة', style: AppTextStyle.textStyle18Bold),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primarySuccess,
                  size: 24.sp,
                ),
                title: Text(
                  'بدء الجلسة',
                  style: AppTextStyle.textStyle16Medium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to live session screen
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: AppColors.primaryBlueViolet,
                  size: 24.sp,
                ),
                title: Text(
                  'تعديل الجلسة',
                  style: AppTextStyle.textStyle16Medium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit session screen
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: AppColors.primaryError,
                  size: 24.sp,
                ),
                title: Text(
                  'إلغاء الجلسة',
                  style: AppTextStyle.textStyle16Medium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Cancel session
                },
              ),
              65.height,
            ],
          ),
        ),
      );
    } else {
      // Navigate to session details for completed sessions
    }
  }
}
