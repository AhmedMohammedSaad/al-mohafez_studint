import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/student_model.dart';

class StudentCardWidget extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final bool isGridView;

  const StudentCardWidget({
    super.key,
    required this.student,
    required this.onTap,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: isGridView ? _buildGridCard() : _buildListCard(),
      ),
    );
  }

  Widget _buildGridCard() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // صورة الطالب
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.lightGrayConstant,
            backgroundImage: student.profileImage != null
                ? NetworkImage(student.profileImage!)
                : null,
            child: student.profileImage == null
                ? Icon(
                    Icons.person,
                    size: 30.sp,
                    color: AppColors.primaryBlueViolet,
                  )
                : null,
          ),
          SizedBox(height: 8.h),

          // اسم الطالب
          Text(
            student.name,
            style: AppTextStyle.font14DarkBlueMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),

          // المستوى الحالي
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _getLevelColor(student.level).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              student.level,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: _getLevelColor(student.level),
              ),
            ),
          ),
          SizedBox(height: 6.h),

          // الجزء الحالي
          Text(
            student.currentPart,
            style: AppTextStyle.font12GreyRegular,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),

          // التقييم وعدد الجلسات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, size: 12.sp, color: Colors.amber),
                  SizedBox(width: 2.w),
                  Text(
                    student.averageRating.toStringAsFixed(1),
                    style: AppTextStyle.font10GreyRegular,
                  ),
                ],
              ),
              Text(
                '${student.totalSessions} جلسة',
                style: AppTextStyle.font10GreyRegular,
              ),
            ],
          ),

          const Spacer(),

          // حالة النشاط
          // Container(
          // width: double.infinity,
          // padding: EdgeInsets.symmetric(vertical: 4.h),
          // decoration: BoxDecoration(
          // color: student.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          // borderRadius: BorderRadius.circular(6.r),
          // ),
          // child: Text(
          // student.isActive ? 'نشط' : 'غير نشط',
          // style: TextStyle(
          // fontSize: 10.sp,
          // fontWeight: FontWeight.w500,
          // color: student.isActive ? Colors.green : Colors.red,
          // ),
          // textAlign: TextAlign.center,
          // ),
          // ),
        ],
      ),
    );
  }

  Widget _buildListCard() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // صورة الطالب
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.lightGrayConstant,
            backgroundImage: student.profileImage != null
                ? NetworkImage(student.profileImage!)
                : null,
            child: student.profileImage == null
                ? Icon(
                    Icons.person,
                    size: 25.sp,
                    color: AppColors.primaryBlueViolet,
                  )
                : null,
          ),
          SizedBox(width: 12.w),

          // معلومات الطالب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم الطالب والمستوى
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        student.name,
                        style: AppTextStyle.font16DarkBlueMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getLevelColor(student.level).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        student.level,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: _getLevelColor(student.level),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // الجزء الحالي
                Text(
                  student.currentPart,
                  style: AppTextStyle.font12GreyRegular,
                ),
                SizedBox(height: 6.h),

                // التقييم وعدد الجلسات والحالة
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, size: 14.sp, color: Colors.amber),
                        SizedBox(width: 2.w),
                        Text(
                          student.averageRating.toStringAsFixed(1),
                          style: AppTextStyle.font12GreyRegular,
                        ),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '${student.totalSessions} جلسة',
                      style: AppTextStyle.font12GreyRegular,
                    ),
                    // const Spacer(),
                    // Container(
                    // padding: EdgeInsets.symmetric(
                    // horizontal: 8.w,
                    // vertical: 2.h,
                    // ),
                    // decoration: BoxDecoration(
                    // color: student.isActive
                    // ? Colors.green.withOpacity(0.1)
                    // : Colors.red.withOpacity(0.1),
                    // borderRadius: BorderRadius.circular(6.r),
                    // ),
                    // child: Text(
                    // student.isActive ? 'نشط' : 'غير نشط',
                    // style: TextStyle(
                    // fontSize: 10.sp,
                    // fontWeight: FontWeight.w500,
                    // color: student.isActive ? Colors.green : Colors.red,
                    // ),
                    // ),
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // سهم للانتقال
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: AppColors.primaryBlueViolet,
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'مبتدئ':
        return Colors.blue;
      case 'متوسط':
        return Colors.orange;
      case 'متقدم':
        return Colors.green;
      default:
        return AppColors.primaryBlueViolet;
    }
  }
}
