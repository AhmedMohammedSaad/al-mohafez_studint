import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

// نموذج تقييم الطالب للشيخ
class StudentEvaluation {
  final String studentName;
  final int rating; // من 1 إلى 5 نجوم
  final String comment;
  final DateTime evaluationDate;

  StudentEvaluation({
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.evaluationDate,
  });
}

class EvaluationsStatsWidget extends StatelessWidget {
  final List<StudentEvaluation> studentEvaluations;

  const EvaluationsStatsWidget({super.key, required this.studentEvaluations});

  @override
  Widget build(BuildContext context) {
    if (studentEvaluations.isEmpty) {
      return _buildEmptyState();
    } else {
      return Expanded(
        child: ListView.separated(
          itemCount: studentEvaluations.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final evaluation = studentEvaluations[index];
            return _buildEvaluationCard(evaluation);
          },
        ),
      );
    }
  }

  Widget _buildHeader() {
    final averageRating = _calculateAverageRating();

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryBlueViolet.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.star_rate_rounded,
            color: AppColors.primaryBlueViolet,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تقييمات الطلاب للشيخ',
                style: AppTextStyle.textStyle20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlueViolet,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'آراء وتقييمات الطلاب حول أداء الشيخ',
                style: AppTextStyle.textStyle12.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        if (studentEvaluations.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _getRatingColor(averageRating).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: _getRatingColor(averageRating),
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: AppTextStyle.textStyle12.copyWith(
                    color: _getRatingColor(averageRating),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEvaluationCard(StudentEvaluation evaluation) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم الطالب والتاريخ
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primaryBlueViolet.withOpacity(0.1),
                child: Text(
                  evaluation.studentName.isNotEmpty
                      ? evaluation.studentName[0].toUpperCase()
                      : 'ط',
                  style: AppTextStyle.textStyle14.copyWith(
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
                      _formatDate(evaluation.evaluationDate),
                      style: AppTextStyle.textStyle10.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // النجوم
              _buildStarRating(evaluation.rating),
            ],
          ),

          SizedBox(height: 12.h),

          // التعليق
          if (evaluation.comment.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.grey, width: 1),
              ),
              child: Text(
                evaluation.comment,
                style: AppTextStyle.textStyle12.copyWith(
                  color: AppColors.black,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? AppColors.orange : AppColors.grey,
          size: 18.sp,
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 48.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'لا توجد تقييمات بعد',
            style: AppTextStyle.textStyle16.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'سيظهر هنا تقييمات الطلاب للشيخ',
            style: AppTextStyle.textStyle12.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating() {
    if (studentEvaluations.isEmpty) return 0.0;

    final totalRating = studentEvaluations.fold<int>(
      0,
      (sum, evaluation) => sum + evaluation.rating,
    );

    return totalRating / studentEvaluations.length;
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return AppColors.green;
    if (rating >= 3.0) return AppColors.orange;
    return AppColors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
