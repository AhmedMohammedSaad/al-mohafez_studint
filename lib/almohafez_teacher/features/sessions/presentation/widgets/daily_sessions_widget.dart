import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../data/models/session_model.dart';

class DailySessionsWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<Session> sessions;
  final Function(Session) onSessionTap;

  const DailySessionsWidget({
    super.key,
    required this.selectedDate,
    required this.sessions,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Text(
                'كل الجلسات',
                style: AppTextStyle.textStyle18Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueViolet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${sessions.length} جلسة',
                  style: AppTextStyle.textStyle12Medium.copyWith(
                    color: AppColors.primaryBlueViolet,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (sessions.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final session = sessions[index];
                return _buildSessionCard(session);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.event_busy, size: 48.sp, color: AppColors.textSecondary),
          SizedBox(height: 16.h),
          Text(
            'لا توجد جلسات',
            style: AppTextStyle.textStyle16Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (session.status) {
      case SessionStatus.scheduled:
        statusColor = AppColors.primaryBlueViolet;
        statusText = 'مجدولة';
        statusIcon = Icons.schedule;
        break;
      case SessionStatus.inProgress:
        statusColor = AppColors.primaryWarning;
        statusText = 'جارية';
        statusIcon = Icons.play_circle;
        break;
      case SessionStatus.completed:
        statusColor = AppColors.primarySuccess;
        statusText = 'مكتملة';
        statusIcon = Icons.check_circle;
        break;
      case SessionStatus.cancelled:
        statusColor = AppColors.primaryError;
        statusText = 'ملغاة';
        statusIcon = Icons.cancel;
        break;
      case SessionStatus.missed:
        statusColor = AppColors.primaryError;
        statusText = 'فائتة';
        statusIcon = Icons.cancel;
        break;
    }

    return GestureDetector(
      onTap: () => onSessionTap(session),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.studentName,
                        style: AppTextStyle.textStyle16Bold,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        session.topic ?? "يوم تحفظ",
                        style: AppTextStyle.textStyle14Medium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyle.textStyle12Bold.copyWith(
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  DateFormat('EEEE', 'ar').format(session.scheduledDate),
                  style: AppTextStyle.textStyle14Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (session.timeSlot != null &&
                    session.timeSlot!.isNotEmpty) ...[
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    session.timeSlot!,
                    style: AppTextStyle.textStyle14Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            10.height,
            if (session.status == SessionStatus.scheduled)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primarySuccess,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'ابدأ الجلسة',
                  style: AppTextStyle.textStyle12Medium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            5.height,
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note,
                      size: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        session.notes!,
                        style: AppTextStyle.textStyle12Medium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
