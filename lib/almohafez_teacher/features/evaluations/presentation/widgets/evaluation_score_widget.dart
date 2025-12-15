import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class EvaluationScoreWidget extends StatelessWidget {
  final String title;
  final double score;
  final ValueChanged<double> onChanged;
  final IconData icon;
  final Color color;
  final double minScore;
  final double maxScore;

  const EvaluationScoreWidget({
    super.key,
    required this.title,
    required this.score,
    required this.onChanged,
    required this.icon,
    required this.color,
    this.minScore = 0.0,
    this.maxScore = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: AppColors.white, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${score.toStringAsFixed(1)}/${maxScore.toInt()}',
                  style: AppTextStyle.textStyle14.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Score Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.3),
              thumbColor: color,
              overlayColor: color.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
              trackHeight: 6.h,
            ),
            child: Slider(
              value: score,
              min: minScore,
              max: maxScore,
              divisions: (maxScore - minScore).toInt() * 2, // 0.5 increments
              onChanged: onChanged,
            ),
          ),

          SizedBox(height: 8.h),

          // Score indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScoreIndicator(minScore.toString(), minScore == score),
              _buildScoreIndicator('5', 5.0 == score),
              _buildScoreIndicator(maxScore.toString(), maxScore == score),
            ],
          ),

          SizedBox(height: 12.h),

          // Performance level indicator
          _buildPerformanceLevel(),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(String value, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        value,
        style: AppTextStyle.textStyle12.copyWith(
          color: isSelected ? AppColors.white : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPerformanceLevel() {
    String level;
    Color levelColor;
    IconData levelIcon;

    if (score >= 8.5) {
      level = 'ممتاز';
      levelColor = AppColors.green;
      levelIcon = Icons.star;
    } else if (score >= 7.0) {
      level = 'جيد جداً';
      levelColor = AppColors.blue;
      levelIcon = Icons.thumb_up;
    } else if (score >= 5.5) {
      level = 'جيد';
      levelColor = AppColors.orange;
      levelIcon = Icons.trending_up;
    } else if (score >= 4.0) {
      level = 'مقبول';
      levelColor = AppColors.yellow;
      levelIcon = Icons.warning;
    } else {
      level = 'يحتاج تحسين';
      levelColor = AppColors.red;
      levelIcon = Icons.trending_down;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: levelColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: levelColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(levelIcon, color: levelColor, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            level,
            style: AppTextStyle.textStyle12.copyWith(
              color: levelColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
