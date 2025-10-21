import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_text_style.dart';

class LanguageToggleWidget extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const LanguageToggleWidget({
    super.key,
    required this.isArabic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // أيقونة العربية
          GestureDetector(
            onTap: () {
              if (!isArabic) onToggle();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isArabic ? const Color(0xFF4DC0C0) : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇸🇦', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 8.w),
                  Text(
                    'عربي',
                    style: AppTextStyle.medium14.copyWith(
                      color: isArabic ? Colors.white : const Color(0xFF666666),
                      fontWeight: isArabic
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // أيقونة الإنجليزية
          GestureDetector(
            onTap: () {
              if (isArabic) onToggle();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: !isArabic ? const Color(0xFF4DC0C0) : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇺🇸', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 8.w),
                  Text(
                    'English',
                    style: AppTextStyle.medium14.copyWith(
                      color: !isArabic ? Colors.white : const Color(0xFF666666),
                      fontWeight: !isArabic
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}