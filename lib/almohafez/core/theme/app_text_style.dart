import 'package:almohafez/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyle {
  static const kDefaultPadding = EdgeInsets.symmetric(
    horizontal: kDefaultPaddingNumber,
  );
  static const double kDefaultPaddingNumber = 10;
  static const double ktoolbarHeight = 70;

  // ========== أنماط النصوص المحسنة لتطبيق المحفظ ==========

  // العناوين الرئيسية
  static TextStyle get textStyle32Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle28Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle24Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle22Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle20Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle18Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle16Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle14Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle12Bold => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  // النصوص المتوسطة
  static TextStyle get textStyle18Medium => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle16Medium => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle14Medium => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle12Medium => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle10Medium => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  // النصوص العادية
  static TextStyle get textStyle16Regular => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle14Regular => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle12Regular => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: FontFamily.cairo,
  );

  // أنماط خاصة للأزرار
  static TextStyle get buttonTextLarge => TextStyle(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get buttonTextMedium => TextStyle(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get buttonTextSmall => TextStyle(
    color: Colors.white,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFamily: FontFamily.cairo,
  );

  // أنماط للنصوص الثانوية
  static TextStyle get captionText => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get hintText => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  // ========== الأنماط القديمة للتوافق ==========

  /// New Organization
  // HEADLINES
  static TextStyle h1 = TextStyle(
    color: AppColors.label,
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle h2 = TextStyle(
    color: AppColors.label,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle h3 = TextStyle(
    color: AppColors.label,
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle h4 = TextStyle(
    color: AppColors.label,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    height: 26 / 20,
  );

  static TextStyle h5 = TextStyle(
    color: AppColors.label,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle h5Medium = TextStyle(
    color: AppColors.label,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle buttonLarge = TextStyle(
    color: AppColors.label,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle buttonSmall = TextStyle(
    color: AppColors.darkGreen500,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle regular16 = TextStyle(
    color: AppColors.label,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
  static TextStyle medium18 = const TextStyle(
    color: Color(0xFF08322A),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );
  static TextStyle medium16 = TextStyle(
    color: AppColors.label,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static TextStyle semiBold16 = TextStyle(
    color: AppColors.label,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  static TextStyle regular14 = TextStyle(
    color: AppColors.label,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle medium14 = TextStyle(
    color: AppColors.label,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static TextStyle semiBold14 = TextStyle(
    color: AppColors.label,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  static TextStyle regular12 = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static TextStyle medium12 = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static TextStyle regular10 = TextStyle(
    color: AppColors.label,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static TextStyle medium10 = TextStyle(
    color: AppColors.label,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static TextStyle regular8 = TextStyle(
    color: AppColors.label,
    fontSize: 8.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // BODY TEXTS
  static TextStyle b1 = TextStyle(
    color: AppColors.label,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    height: 20 / 16,
    letterSpacing: 0.01 * 16, // 1% kerning
  );

  static TextStyle b2 = TextStyle(
    color: AppColors.primaryColor2,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    height: 22 / 14,
    letterSpacing: 0.01 * 14,
  );
  static TextStyle b3 = TextStyle(
    color: AppColors.label,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    height: 15 / 14,
    letterSpacing: 0.01 * 14,
  );

  static TextStyle b4 = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    height: 20 / 12,
    letterSpacing: 0.01 * 12,
  );

  static TextStyle b5 = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    height: 18 / 12,
    letterSpacing: 0.01 * 12,
  );
  static TextStyle buttonText = TextStyle(
    color: AppColors.label,
    fontSize: 14.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.01 * 14,
  );
  static TextStyle button = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle navbar1 = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle navbar2 = TextStyle(
    color: AppColors.label,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );

  //  Old Styles
  static TextStyle appNameStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle titleText = TextStyle(
    color: AppColors.label,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle subTitle = TextStyle(
    color: AppColors.label,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textButton = TextStyle(
    color: AppColors.label,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle titleStyle = TextStyle(
    color: AppColors.label,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle font14error400 = TextStyle(
    color: AppColors.error,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle font16darkGray400 = TextStyle(
    color: AppColors.darkGray,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle font28black700 = TextStyle(
    color: AppColors.black,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font16black700 = TextStyle(
    color: AppColors.black,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle font16white700 = TextStyle(
    color: AppColors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle font14darkGray500 = TextStyle(
    color: Colors.grey,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle font14SecondaryW700 = TextStyle(
    color: AppColors.textSecondryColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle font14primaryColor500 = TextStyle(
    color: AppColors.primary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle font20Blackw700 = TextStyle(
    color: AppColors.black,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  // Legacy text styles for compatibility
  static TextStyle font12WhiteMedium = TextStyle(
    color: AppColors.primaryWhite,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font12GreyMedium = TextStyle(
    color: AppColors.grey,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font14DarkBlueRegular = TextStyle(
    color: AppColors.primaryBlueViolet,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font14GreyRegular = TextStyle(
    color: AppColors.grey,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font10GreyRegular = TextStyle(
    color: AppColors.grey,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font12DarkBlueMedium = TextStyle(
    color: AppColors.primaryBlueViolet,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font14DarkBlueMedium = TextStyle(
    color: AppColors.primaryBlueViolet,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font12GreyRegular = TextStyle(
    color: AppColors.grey,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font14DarkBlueBold = TextStyle(
    color: AppColors.primaryDark,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font16DarkBlueMedium = TextStyle(
    color: AppColors.primaryDark,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font16DarkBlueBold = TextStyle(
    color: AppColors.primaryDark,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font20DarkBlueBold = TextStyle(
    color: AppColors.primaryDark,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle font12DarkBlueRegular = TextStyle(
    color: AppColors.primaryDark,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.cairo,
  );
  // Plain text styles (default weight)
  static TextStyle get textStyle20 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle18 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle16 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle14 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle12 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle10 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );

  static TextStyle get textStyle8 => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 8.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: FontFamily.cairo,
  );
}

extension TextStyleExt on TextStyle {
  TextStyle bold() => copyWith(fontWeight: FontWeight.bold);

  TextStyle lightBold() => copyWith(fontWeight: FontWeight.w700);

  TextStyle comfort() => copyWith(height: 1.8);

  TextStyle dense() => copyWith(height: 1.2);

  TextStyle rotunda() => copyWith(fontFamily: FontFamily.roboto);
}
