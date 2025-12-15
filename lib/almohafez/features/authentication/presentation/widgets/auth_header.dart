import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? logo;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logo,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back button and logo row
        if (showBackButton || logo != null)
          Padding(
            padding: EdgeInsets.only(bottom: 32.h),
            child: Row(
              children: [
                if (showBackButton)
                  IconButton(
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryDark,
                      size: 20.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                  ),
                const Spacer(),
                if (logo != null) logo!,
                const Spacer(),
                if (showBackButton)
                  SizedBox(width: 40.w), // Balance the back button
              ],
            ),
          ),

        // Title
        Text(
          title,
          style: AppTextStyle.h1.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 12.h),

        // Subtitle
        Text(
          subtitle,
          style: AppTextStyle.medium16.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 40.h),
      ],
    );
  }
}
