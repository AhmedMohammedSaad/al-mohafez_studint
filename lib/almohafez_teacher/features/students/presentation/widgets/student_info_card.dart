import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/student_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class StudentInfoCard extends StatelessWidget {
  final Student student;

  const StudentInfoCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // الصف الأول - الإحصائيات الرئيسية
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'إجمالي الجلسات',
                  '${student.totalSessions}',
                  Icons.schedule,
                  AppColors.primaryBlueViolet,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: AppColors.lightGrayConstant,
              ),
              Expanded(
                child: _buildStatItem(
                  'متوسط التقييم',
                  student.averageRating.toStringAsFixed(1),
                  Icons.star,
                  Colors.amber,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: AppColors.lightGrayConstant,
              ),
              // Expanded(
              //   child: _buildStatItem(
              //     'الأجزاء المكتملة',
              //     '${student.completedParts.length}',
              //     Icons.check_circle,
              //     Colors.green,
              //   ),
              // ),
            ],
          ),

          Divider(height: 24.h, color: AppColors.lightGrayConstant),

          // الصف الثاني - معلومات التقدم
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الجزء الحالي', style: AppTextStyle.font12GreyMedium),
                    SizedBox(height: 4.h),
                    Text(
                      student.currentPart,
                      style: AppTextStyle.font14DarkBlueMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاريخ الانضمام',
                      style: AppTextStyle.font12GreyMedium,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('dd/MM/yyyy').format(student.joinDate),
                      style: AppTextStyle.font14DarkBlueMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // الصف الثالث - معلومات الاتصال
          // Row(
          //   children: [
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('رقم الهاتف', style: AppTextStyle.font12GreyMedium),
          //           SizedBox(height: 4.h),
          //           Text(
          //             student.phone,
          //             style: AppTextStyle.font14DarkBlueMedium,
          //           ),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'البريد الإلكتروني',
          //             style: AppTextStyle.font12GreyMedium,
          //           ),
          //           SizedBox(height: 4.h),
          //           Text(
          //             student.email,
          //             style: AppTextStyle.font14DarkBlueMedium,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 16.h),

          // شريط التقدم
          // Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // children: [
          // Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: [
          // Text(
          // 'التقدم الإجمالي',
          // style: AppTextStyle.font12GreyMedium,
          // ),
          // Text(
          // '${((student.completedParts.length / 30) * 100).toInt()}%',
          // style: AppTextStyle.font12DarkBlueMedium,
          // ),
          // ],
          // ),
          // SizedBox(height: 8.h),
          // LinearProgressIndicator(
          // value: student.completedParts.length / 30,
          // backgroundColor: AppColors.lightGrayConstant,
          // valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor2),
          // minHeight: 6.h,
          // ),
          // ],
          // ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 5.h),
        Text(value, style: AppTextStyle.font16DarkBlueBold),
        SizedBox(height: 7.h),
        Text(
          title,
          style: AppTextStyle.font10GreyRegular.copyWith(
            color: AppColors.newGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
