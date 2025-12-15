import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../data/models/evaluation_model.dart';

class EvaluationCardWidget extends StatelessWidget {
  final Evaluation evaluation;
  final VoidCallback onTap;

  const EvaluationCardWidget({
    super.key,
    required this.evaluation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final performanceLevel = _getPerformanceLevel(evaluation.averageScore);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: performanceLevel.color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with student name and date
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.primaryBlueViolet.withOpacity(0.1),
                  child: Text(
                    evaluation.studentName[0],
                    style: AppTextStyle.textStyle16.copyWith(
                      color: AppColors.primaryBlueViolet,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evaluation.studentName,
                        style: AppTextStyle.textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlueViolet,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy - HH:mm',
                          'ar',
                        ).format(evaluation.evaluationDate),
                        style: AppTextStyle.textStyle12.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: performanceLevel.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: performanceLevel.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        performanceLevel.icon,
                        color: performanceLevel.color,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        performanceLevel.label,
                        style: AppTextStyle.textStyle10.copyWith(
                          color: performanceLevel.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Scores Section
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildScoreItem(
                          'الحفظ',
                          evaluation.memorizationScore,
                          Icons.menu_book,
                          AppColors.blue,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildScoreItem(
                          'التجويد',
                          evaluation.tajweedScore,
                          Icons.record_voice_over,
                          AppColors.green,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildScoreItem(
                          'الأداء العام',
                          evaluation.overallPerformance,
                          Icons.star,
                          AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: performanceLevel.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calculate,
                          color: performanceLevel.color,
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'المتوسط العام: ${evaluation.averageScore.toStringAsFixed(1)}/10',
                          style: AppTextStyle.textStyle14.copyWith(
                            color: performanceLevel.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Topics and Notes
            if (evaluation.topics.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.topic,
                    color: AppColors.primaryBlueViolet,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'المواضيع: ',
                    style: AppTextStyle.textStyle12.copyWith(
                      color: AppColors.primaryBlueViolet,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      evaluation.topics.join(', '),
                      style: AppTextStyle.textStyle12.copyWith(
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],

            if (evaluation.notes != null && evaluation.notes!.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note_alt, color: AppColors.blue, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'ملاحظات: ',
                    style: AppTextStyle.textStyle12.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      evaluation.notes!,
                      style: AppTextStyle.textStyle12.copyWith(
                        color: AppColors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],

            // Completion Status
            Row(
              children: [
                Icon(
                  evaluation.isCompleted ? Icons.check_circle : Icons.pending,
                  color: evaluation.isCompleted
                      ? AppColors.green
                      : AppColors.orange,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  evaluation.isCompleted
                      ? 'تم إنجاز الأهداف'
                      : 'لم يتم إنجاز جميع الأهداف',
                  style: AppTextStyle.textStyle12.copyWith(
                    color: evaluation.isCompleted
                        ? AppColors.green
                        : AppColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey,
                  size: 14.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(
    String title,
    double score,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16.sp),
        SizedBox(height: 4.h),
        Text(
          '${score.toStringAsFixed(1)}',
          style: AppTextStyle.textStyle14.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: AppTextStyle.textStyle10.copyWith(color: color),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  PerformanceLevel _getPerformanceLevel(double score) {
    if (score >= 8.5) {
      return PerformanceLevel(
        label: 'ممتاز',
        color: AppColors.green,
        icon: Icons.emoji_events,
      );
    } else if (score >= 7.0) {
      return PerformanceLevel(
        label: 'جيد جداً',
        color: AppColors.blue,
        icon: Icons.thumb_up,
      );
    } else if (score >= 5.5) {
      return PerformanceLevel(
        label: 'جيد',
        color: AppColors.orange,
        icon: Icons.trending_up,
      );
    } else if (score >= 4.0) {
      return PerformanceLevel(
        label: 'مقبول',
        color: AppColors.yellow,
        icon: Icons.warning,
      );
    } else {
      return PerformanceLevel(
        label: 'يحتاج تحسين',
        color: AppColors.red,
        icon: Icons.trending_down,
      );
    }
  }
}

class PerformanceLevel {
  final String label;
  final Color color;
  final IconData icon;

  PerformanceLevel({
    required this.label,
    required this.color,
    required this.icon,
  });
}
