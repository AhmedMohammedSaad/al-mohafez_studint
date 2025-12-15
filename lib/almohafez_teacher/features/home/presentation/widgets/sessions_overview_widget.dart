import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../sessions/data/models/session_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SessionsOverviewWidget extends StatelessWidget {
  const SessionsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للجلسات
    final List<Session> todaySessions = [
      Session(
        id: '1',
        studentId: 'student1',
        studentName: 'أحمد محمد',
        scheduledDate: DateTime.now().add(const Duration(hours: 2)),
        duration: const Duration(minutes: 60),
        type: SessionType.review,
        status: SessionStatus.scheduled,
        notes: 'مراجعة الحفظ السابق',
        topic: 'سورة البقرة',
        startTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      Session(
        id: '2',
        studentId: 'student2',
        studentName: 'فاطمة علي',
        scheduledDate: DateTime.now().add(const Duration(hours: 4)),
        duration: const Duration(minutes: 45),
        type: SessionType.memorization,
        status: SessionStatus.scheduled,
        notes: 'حفظ جديد',
        topic: 'سورة آل عمران',
        startTime: DateTime.now().add(const Duration(hours: 4)),
      ),
    ];

    final int totalSessions = 15;
    final int completedSessions = 8;
    final int scheduledSessions = 5;
    final int cancelledSessions = 2;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نظرة عامة على الجلسات',
                style: AppTextStyle.textStyle22Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // الانتقال إلى شاشة الجلسات
                },
                child: Text(
                  'عرض الكل',
                  style: AppTextStyle.textStyle14Medium.copyWith(
                    color: AppColors.primaryBlueViolet,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // إحصائيات الجلسات
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'إجمالي الجلسات',
                  value: totalSessions.toString(),
                  color: AppColors.primaryBlueViolet,
                  icon: Icons.video_call_rounded,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildStatCard(
                  title: 'مكتملة',
                  value: completedSessions.toString(),
                  color: AppColors.primarySuccess,
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'مجدولة',
                  value: scheduledSessions.toString(),
                  color: AppColors.primaryWarning,
                  icon: Icons.schedule_rounded,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildStatCard(
                  title: 'ملغية',
                  value: cancelledSessions.toString(),
                  color: AppColors.primaryError,
                  icon: Icons.cancel_rounded,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // جلسات اليوم
          Text(
            'جلسات اليوم',
            style: AppTextStyle.textStyle18Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 12.h),

          if (todaySessions.isEmpty)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available_rounded,
                      size: 40.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'لا توجد جلسات مجدولة لليوم',
                      style: AppTextStyle.textStyle14Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...todaySessions.map((session) => _buildSessionCard(session)),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyle.textStyle20Bold.copyWith(color: color),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTextStyle.textStyle12Regular.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          // أيقونة الحالة
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: _getStatusColor(session.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getStatusIcon(session.status),
              color: _getStatusColor(session.status),
              size: 20.sp,
            ),
          ),

          SizedBox(width: 12.w),

          // تفاصيل الجلسة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.studentName,
                  style: AppTextStyle.textStyle14Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  session.topic ?? '',
                  style: AppTextStyle.textStyle12Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${DateFormat('HH:mm').format(session.startTime ?? DateTime.now())} - ${session.duration} دقيقة',
                  style: AppTextStyle.textStyle12Medium.copyWith(
                    color: AppColors.primaryBlueViolet,
                  ),
                ),
              ],
            ),
          ),

          // زر الإجراء
          IconButton(
            onPressed: () {
              // فتح تفاصيل الجلسة
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled:
        return AppColors.primaryWarning;
      case SessionStatus.inProgress:
        return AppColors.primaryBlueViolet;
      case SessionStatus.completed:
        return AppColors.primarySuccess;
      case SessionStatus.cancelled:
        return AppColors.primaryError;
      case SessionStatus.missed:
        return AppColors.primaryError;
    }
  }

  IconData _getStatusIcon(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled:
        return Icons.schedule_rounded;
      case SessionStatus.inProgress:
        return Icons.play_circle_rounded;
      case SessionStatus.completed:
        return Icons.check_circle_rounded;
      case SessionStatus.cancelled:
        return Icons.cancel_rounded;
      case SessionStatus.missed:
        return Icons.error_rounded;
    }
  }
}
