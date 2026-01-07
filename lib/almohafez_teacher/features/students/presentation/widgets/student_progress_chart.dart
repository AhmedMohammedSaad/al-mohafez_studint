import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/student_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class StudentProgressChart extends StatelessWidget {
  final Student student;

  const StudentProgressChart({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تقدم الطالب', style: AppTextStyle.font16DarkBlueBold),
          SizedBox(height: 16.h),

          // مخطط دائري للتقدم الإجمالي
          SizedBox(
            height: 120.h,
            child: Row(
              children: [
                // الدائرة التقدمية
                SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child: Stack(
                    children: [
                      // الخلفية
                      SizedBox(
                        width: 120.w,
                        height: 120.h,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 8.w,
                          backgroundColor: AppColors.lightGrayConstant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.lightGrayConstant,
                          ),
                        ),
                      ),
                      // التقدم
                      SizedBox(
                        width: 120.w,
                        height: 120.h,
                        child: CircularProgressIndicator(
                          value: student.completedParts.length / 30,
                          strokeWidth: 8.w,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor2,
                          ),
                        ),
                      ),
                      // النص في المنتصف
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${((student.completedParts.length / 30) * 100).toInt()}%',
                              style: AppTextStyle.font20DarkBlueBold,
                            ),
                            Text(
                              'مكتمل',
                              style: AppTextStyle.font12GreyRegular,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),

                // الإحصائيات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressItem(
                        'الأجزاء المكتملة',
                        '${student.completedParts.length} من 30',
                        Colors.green,
                      ),
                      SizedBox(height: 8.h),
                      _buildProgressItem(
                        'الجزء الحالي',
                        student.currentPart,
                        AppColors.primaryBlueViolet,
                      ),
                      SizedBox(height: 8.h),
                      _buildProgressItem(
                        'متوسط التقييم',
                        '${student.averageRating}/5',
                        Colors.amber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // قائمة الأجزاء المكتملة
          Text('الأجزاء المكتملة', style: AppTextStyle.font14DarkBlueBold),
          SizedBox(height: 12.h),

          Expanded(
            child: student.completedParts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 48.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'لم يكمل أي جزء بعد',
                          style: AppTextStyle.font14GreyRegular,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                    ),
                    itemCount: student.completedParts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            student.completedParts[index],
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.font10GreyRegular),
              Text(value, style: AppTextStyle.font12DarkBlueMedium),
            ],
          ),
        ),
      ],
    );
  }
}
