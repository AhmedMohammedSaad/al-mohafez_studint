import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/generated/assets.dart';

import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class AppDefaultButton extends StatelessWidget {
  const AppDefaultButton({
    super.key,
    required this.buttonText,
    required this.ontap,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isTransparent = false,
    this.buttonTextStyle,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.spacing,
    this.isIconLeading = true,
    this.imagePath,
    this.isAnimate = true,
    this.isTextRow = false,
    this.borderRadius,
    Color? colors,
  });
  final String buttonText;
  final double? borderRadius;
  final Function? ontap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isTransparent;
  final TextStyle? buttonTextStyle;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? spacing;
  final bool isIconLeading;
  final String? imagePath;
  final bool isAnimate;
  final bool isTextRow;

  @override
  Widget build(BuildContext context) {
    // Cache color calculations to avoid repeated operations
    final Color defaultBackgroundColor = AppColors.primaryColor2;
    const Color defaultTextColor = AppColors.whiteConstant;

    final Color actualBackgroundColor = isLoading
        ? AppColors.darkGray
        : isTransparent
        ? Colors.transparent
        : backgroundColor ?? defaultBackgroundColor;

    final Color actualTextColor = textColor ?? defaultTextColor;
    final Color actualIconColor = iconColor ?? actualTextColor;

    Widget button = RepaintBoundary(
      child: Container(
        width: width ?? 321.sp,
        height: height ?? 56.h,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: actualBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.sp)
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 25.h,
                  width: 25.w,
                  child: const CircularProgressIndicator(
                    backgroundColor: AppColors.whiteConstant,
                    strokeWidth: 2.0,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null && isIconLeading) ...[
                      Icon(
                        icon,
                        color: actualIconColor,
                        size: iconSize ?? 24.sp,
                      ),
                      SizedBox(width: spacing ?? 8.w),
                    ] else if (imagePath != null && isIconLeading) ...[
                      AppCustomImageView(
                        imagePath: imagePath,
                        color: actualTextColor,
                      ).paddingOnly(right: 10.w),
                    ],
                    isTextRow
                        ? Row(
                            children: [
                              const AppCustomImageView(
                                imagePath: AssetData.svgPlus,
                              ),
                              8.width,
                              Text(
                                buttonText,
                                style:
                                    buttonTextStyle ??
                                    AppTextStyle.font16white700.copyWith(
                                      color: actualTextColor,
                                    ),
                              ),
                            ],
                          )
                        : Text(
                            buttonText,
                            style:
                                buttonTextStyle ??
                                AppTextStyle.font16darkGray400.copyWith(
                                  color: actualTextColor,
                                ),
                          ),
                    if (icon != null && !isIconLeading) ...[
                      SizedBox(width: spacing ?? 8.w),
                      Icon(
                        icon,
                        color: actualIconColor,
                        size: iconSize ?? 24.sp,
                      ),
                    ] else if (imagePath != null && !isIconLeading) ...[
                      SizedBox(width: spacing ?? 8.w),
                      AppCustomImageView(
                        imagePath: imagePath,
                        color: actualTextColor,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    ).onTap(isLoading ? null : ontap);

    // Apply animation only if isAnimate is true
    if (isAnimate) {
      button = button.animate().slide();
    }

    return button;
  }
}
