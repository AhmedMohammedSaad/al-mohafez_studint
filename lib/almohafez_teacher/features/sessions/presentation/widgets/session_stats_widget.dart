import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../data/models/session_model.dart';

class SessionStatsWidget extends StatelessWidget {
  final List<Session> sessions;

  const SessionStatsWidget({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todaySessions = sessions.where((session) {
      return session.scheduledDate.year == today.year &&
          session.scheduledDate.month == today.month &&
          session.scheduledDate.day == today.day;
    }).toList();

    final thisWeekSessions = sessions.where((session) {
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return session.scheduledDate.isAfter(
            weekStart.subtract(const Duration(days: 1)),
          ) &&
          session.scheduledDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();

    final completedSessions = sessions
        .where((session) => session.status == SessionStatus.completed)
        .length;

    final scheduledSessions = sessions
        .where((session) => session.status == SessionStatus.scheduled)
        .length;

    final cancelledSessions = sessions
        .where((session) => session.status == SessionStatus.cancelled)
        .length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات الجلسات',
            style: AppTextStyle.textStyle18Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'اليوم',
                  value: todaySessions.length.toString(),
                  icon: Icons.today,
                  color: AppColors.primaryBlueViolet,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'هذا الأسبوع',
                  value: thisWeekSessions.length.toString(),
                  icon: Icons.date_range,
                  color: AppColors.primarySuccess,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'مكتملة',
                  value: completedSessions.toString(),
                  icon: Icons.check_circle,
                  color: AppColors.primarySuccess,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'مجدولة',
                  value: scheduledSessions.toString(),
                  icon: Icons.schedule,
                  color: AppColors.primaryWarning,
                ),
              ),
            ],
          ),
          if (cancelledSessions > 0) ...[
            SizedBox(height: 12.h),
            _buildStatCard(
              title: 'ملغاة',
              value: cancelledSessions.toString(),
              icon: Icons.cancel,
              color: AppColors.primaryError,
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: fullWidth
          ? Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: AppTextStyle.textStyle20Bold.copyWith(
                          color: color,
                        ),
                      ),
                      Text(
                        title,
                        style: AppTextStyle.textStyle14Medium.copyWith(
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 24.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: AppTextStyle.textStyle20Bold.copyWith(color: color),
                ),
                Text(
                  title,
                  style: AppTextStyle.textStyle12Medium.copyWith(color: color),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
