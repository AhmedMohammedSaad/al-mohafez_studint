import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class EvaluationNotesWidget extends StatelessWidget {
  final TextEditingController notesController;
  final TextEditingController strengthsController;
  final TextEditingController improvementsController;
  final TextEditingController nextGoalsController;

  const EvaluationNotesWidget({
    super.key,
    required this.notesController,
    required this.strengthsController,
    required this.improvementsController,
    required this.nextGoalsController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          Text(
            'الملاحظات والتقييم',
            style: AppTextStyle.textStyle18.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueViolet,
            ),
          ),
          SizedBox(height: 16.h),

          // General Notes
          _buildNoteField(
            controller: notesController,
            title: 'ملاحظات عامة',
            hint: 'اكتب ملاحظاتك حول أداء الطالب في هذه الجلسة...',
            icon: Icons.note_alt,
            color: AppColors.blue,
            maxLines: 3,
          ),

          SizedBox(height: 16.h),

          // Strengths
          _buildNoteField(
            controller: strengthsController,
            title: 'نقاط القوة',
            hint: 'اذكر نقاط القوة التي لاحظتها على الطالب...',
            icon: Icons.star,
            color: AppColors.green,
            maxLines: 2,
          ),

          SizedBox(height: 16.h),

          // Areas for Improvement
          _buildNoteField(
            controller: improvementsController,
            title: 'نقاط التحسين',
            hint: 'اذكر النقاط التي يحتاج الطالب لتحسينها...',
            icon: Icons.trending_up,
            color: AppColors.orange,
            maxLines: 2,
          ),

          SizedBox(height: 16.h),

          // Next Session Goals
          _buildNoteField(
            controller: nextGoalsController,
            title: 'أهداف الجلسة القادمة',
            hint: 'حدد الأهداف المطلوب تحقيقها في الجلسة القادمة...',
            icon: Icons.flag,
            color: AppColors.purple,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField({
    required TextEditingController controller,
    required String title,
    required String hint,
    required IconData icon,
    required Color color,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(icon, color: color, size: 16.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: AppTextStyle.textStyle14.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyle.textStyle14,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.textStyle14.copyWith(color: AppColors.grey),
            filled: true,
            fillColor: color.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: color.withOpacity(0.3), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: color.withOpacity(0.3), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: color, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
          validator: (value) {
            if (title == 'ملاحظات عامة' &&
                (value == null || value.trim().isEmpty)) {
              return 'يرجى إدخال ملاحظات عامة';
            }
            return null;
          },
        ),
      ],
    );
  }
}
