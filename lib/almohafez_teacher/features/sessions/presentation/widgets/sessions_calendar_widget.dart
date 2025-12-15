import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../data/models/session_model.dart';

class SessionsCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<Session> sessions;
  final Function(DateTime) onDateSelected;

  const SessionsCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.sessions,
    required this.onDateSelected,
  });

  List<Session> _getSessionsForDay(DateTime day) {
    return sessions.where((session) {
      return session.scheduledDate.year == day.year &&
          session.scheduledDate.month == day.month &&
          session.scheduledDate.day == day.day;
    }).toList();
  }

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
          Text(
            'التقويم',
            style: AppTextStyle.textStyle18Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateChanged: (DateTime value) {
              onDateSelected(value);
            },
          ),
          SizedBox(height: 16.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('مجدولة', AppColors.primaryBlueViolet),
              _buildLegendItem('جارية', AppColors.primaryWarning),
              _buildLegendItem('مكتملة', AppColors.primarySuccess),
              _buildLegendItem('ملغاة', AppColors.primaryError),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyle.textStyle12Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
