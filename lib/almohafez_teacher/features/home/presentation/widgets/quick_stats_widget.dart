import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للإحصائيات
    final int totalStudents = 25;
    final int activeSessions = 3;
    final int completedEvaluations = 18;
    final double averageScore = 8.5;

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
          Text(
            'إحصائيات سريعة',
            style: AppTextStyle.textStyle18Bold.copyWith(
              color: AppColors.primaryBlueViolet,
            ),
          ),

          SizedBox(height: 16.h),

          // الصف الأول من الإحصائيات
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'إجمالي الطلاب',
                  value: totalStudents.toString(),
                  color: AppColors.primaryBlueViolet,
                  icon: Icons.school_rounded,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'الجلسات النشطة',
                  value: activeSessions.toString(),
                  color: AppColors.primarySuccess,
                  icon: Icons.video_call_rounded,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // الصف الثاني من الإحصائيات
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'التقييمات المكتملة',
                  value: completedEvaluations.toString(),
                  color: AppColors.primaryWarning,
                  icon: Icons.assignment_turned_in_rounded,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'متوسط الدرجات',
                  value: averageScore.toString(),
                  color: AppColors.primaryError,
                  icon: Icons.star_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              const Spacer(),
              Text(
                value,
                style: AppTextStyle.textStyle24Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyle.textStyle14Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
