import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../evaluations/data/models/evaluation_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class StudentEvaluationsList extends StatelessWidget {
  final List<Evaluation> evaluations;

  const StudentEvaluationsList({super.key, required this.evaluations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('آخر التقييمات', style: AppTextStyle.font16DarkBlueBold),
          SizedBox(height: 16.h),

          Expanded(
            child: evaluations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: evaluations.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildEvaluationCard(evaluations[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment_outlined, size: 48.sp, color: Colors.grey[400]),
          SizedBox(height: 8.h),
          Text('لا توجد تقييمات', style: AppTextStyle.font14GreyRegular),
        ],
      ),
    );
  }

  Widget _buildEvaluationCard(Evaluation evaluation) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGrayConstant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // التاريخ والدرجة الإجمالية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate),
                style: AppTextStyle.font12GreyMedium,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getPerformanceColor(
                    evaluation.overallPerformance,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${evaluation.overallPerformance.toStringAsFixed(1)}/5',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getPerformanceColor(evaluation.overallPerformance),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // الدرجات التفصيلية
          Row(
            children: [
              Expanded(
                child: _buildScoreItem(
                  'الحفظ',
                  evaluation.memorizationScore,
                  Icons.memory,
                ),
              ),
              Expanded(
                child: _buildScoreItem(
                  'التجويد',
                  evaluation.tajweedScore,
                  Icons.record_voice_over,
                ),
              ),
              Expanded(
                child: _buildScoreItem(
                  'الأداء العام',
                  evaluation.overallPerformance,
                  Icons.trending_up,
                ),
              ),
            ],
          ),

          if (evaluation.notes != null && evaluation.notes!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrayConstant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                evaluation.notes!,
                style: AppTextStyle.font12DarkBlueRegular,
              ),
            ),
          ],

          if (evaluation.topics.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 4.w,
              runSpacing: 4.h,
              children: evaluation.topics.map((topic) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueViolet.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.primaryBlueViolet,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreItem(String title, double score, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16.sp, color: _getPerformanceColor(score)),
        SizedBox(height: 4.h),
        Text(
          score.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: _getPerformanceColor(score),
          ),
        ),
        Text(
          title,
          style: AppTextStyle.font10GreyRegular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 4.5) return Colors.green;
    if (score >= 3.5) return Colors.orange;
    return Colors.red;
  }
}
