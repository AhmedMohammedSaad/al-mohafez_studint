import 'package:almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'tutors_list_screen.dart';

class GenderSelectionScreen extends StatelessWidget {
  const GenderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: Text(
      //     'اختيار نوع المحفظ',
      //     style: TextStyle(
      //       fontFamily: 'Cairo',
      //       fontSize: 22.sp,
      //       fontWeight: FontWeight.bold,
      //       color: const Color(0xFF0A1D64),
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text(
              'teachers_gender_selection_title'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5B6C9F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.h),
            Expanded(
              child: Column(
                children: [
                  // خيار المحفظين الرجال
                  _buildGenderOption(
                    context: context,
                    title: 'teachers_male_option'.tr(),
                    subtitle: 'teachers_male_subtitle'.tr(),
                    icon: AppCustomImageView(
                      imagePath: 'assets/images/shaegh.jpg',
                    ),
                    color: const Color(0xFF0A1D64),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TutorsListScreen(gender: 'male'),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  // خيار المحفظات النساء
                  _buildGenderOption(
                    context: context,
                    title: 'teachers_female_option'.tr(),
                    subtitle: 'teachers_female_subtitle'.tr(),
                    icon: AppCustomImageView(
                      imagePath: 'assets/images/niqab-5.jpg',
                    ),
                    color: const Color(0xFF00E0FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TutorsListScreen(gender: 'female'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: icon,
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A1D64),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: const Color(0xFF5B6C9F),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
