import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

enum AuthButtonType { primary, secondary, outline, text }

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AuthButtonType type;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AuthButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !isEnabled || isLoading || onPressed == null;

    return Container(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: type == AuthButtonType.primary && !isDisabled
            ? [
                BoxShadow(
                  color: AppColors.primaryBlueViolet.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isDisabled),
          foregroundColor: _getForegroundColor(isDisabled),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: _getBorderSide(isDisabled),
          ),
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, SizedBox(width: 8.w)],
                  Text(text, style: _getTextStyle(isDisabled)),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.borderLight;
    }

    switch (type) {
      case AuthButtonType.primary:
        return AppColors.primaryBlueViolet;
      case AuthButtonType.secondary:
        return AppColors.backgroundSection;
      case AuthButtonType.outline:
      case AuthButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.textSecondary;
    }

    switch (type) {
      case AuthButtonType.primary:
        return AppColors.primaryWhite;
      case AuthButtonType.secondary:
        return AppColors.primaryBlueViolet;
      case AuthButtonType.outline:
        return AppColors.primaryBlueViolet;
      case AuthButtonType.text:
        return AppColors.primaryBlueViolet;
    }
  }

  BorderSide _getBorderSide(bool isDisabled) {
    if (type == AuthButtonType.outline) {
      return BorderSide(
        color: isDisabled ? AppColors.borderLight : AppColors.primaryBlueViolet,
        width: 1.5,
      );
    }
    return BorderSide.none;
  }

  Color _getLoadingColor() {
    switch (type) {
      case AuthButtonType.primary:
        return AppColors.primaryWhite;
      case AuthButtonType.secondary:
      case AuthButtonType.outline:
      case AuthButtonType.text:
        return AppColors.primaryBlueViolet;
    }
  }

  TextStyle _getTextStyle(bool isDisabled) {
    final baseStyle = AppTextStyle.medium16.copyWith(
      fontWeight: FontWeight.w600,
    );

    if (isDisabled) {
      return baseStyle.copyWith(color: AppColors.textSecondary);
    }

    switch (type) {
      case AuthButtonType.primary:
        return baseStyle.copyWith(color: AppColors.primaryWhite);
      case AuthButtonType.secondary:
      case AuthButtonType.outline:
      case AuthButtonType.text:
        return baseStyle.copyWith(color: AppColors.primaryBlueViolet);
    }
  }
}
