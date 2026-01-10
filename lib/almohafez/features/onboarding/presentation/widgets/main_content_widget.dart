import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class MainContentWidget extends StatelessWidget {
  const MainContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // العنوان الرئيسي
        Text(
          'onboarding_title'.tr(),
          style: AppTextStyle.h1.copyWith(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 16.h),

        // الوصف
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'onboarding_description'.tr(),
            style: AppTextStyle.medium16.copyWith(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
