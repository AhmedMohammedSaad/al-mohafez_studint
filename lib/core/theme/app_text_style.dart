import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import 'app_colors.dart';

class AppTextStyle {
  static const kDefaultPadding = EdgeInsets.symmetric(horizontal: kDefaultPaddingNumber);
  static const double kDefaultPaddingNumber = 10;
  static const double ktoolbarHeight = 70;

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
}

extension TextStyleExt on TextStyle {
  TextStyle bold() => copyWith(fontWeight: FontWeight.bold);

  TextStyle lightBold() => copyWith(fontWeight: FontWeight.w700);

  TextStyle comfort() => copyWith(height: 1.8);

  TextStyle dense() => copyWith(height: 1.2);

  TextStyle rotunda() => copyWith(fontFamily: FontFamily.roboto);
}
