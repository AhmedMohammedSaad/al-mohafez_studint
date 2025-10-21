import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeBarWidget extends StatelessWidget {
  const WelcomeBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'welcome_greeting'.tr(namedArgs: {'username': 'أحمد'}),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'welcome_message'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF5B6C9F),
            ),
          ),
        ],
      ),
    );
  }
}