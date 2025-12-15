import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

enum SocialLoginType { google, facebook }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? customText;

  const SocialLoginButton({
    super.key,
    required this.type,
    this.onPressed,
    this.isLoading = false,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.borderLight, width: 1.5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textSecondary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getIcon(),
                  SizedBox(width: 12.w),
                  Text(
                    customText ?? _getDefaultText(),
                    style: AppTextStyle.medium16.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case SocialLoginType.google:
        return AppColors.primaryWhite;
      case SocialLoginType.facebook:
        return const Color(0xFF1877F2);
    }
  }

  Color _getForegroundColor() {
    switch (type) {
      case SocialLoginType.google:
        return AppColors.primaryDark;
      case SocialLoginType.facebook:
        return AppColors.primaryWhite;
    }
  }

  Widget _getIcon() {
    switch (type) {
      case SocialLoginType.google:
        return Container(
          width: 24.w,
          height: 24.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://developers.google.com/identity/images/g-logo.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        );
      case SocialLoginType.facebook:
        return Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'f',
              style: TextStyle(
                color: const Color(0xFF1877F2),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }

  String _getDefaultText() {
    switch (type) {
      case SocialLoginType.google:
        return 'Continue with Google';
      case SocialLoginType.facebook:
        return 'Continue with Facebook';
    }
  }
}
