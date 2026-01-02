import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  /// ثيم تطبيق المحفظ الفاتح
  static ThemeData appLightTheme(
    String fontFamily, {
    Color? scaffoldBackgroundColor,
  }) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: scaffoldBackgroundColor ?? Colors.white,
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,

    // إعدادات شريط التطبيق
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryWhite,
      foregroundColor: AppColors.primaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.primaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColors.primaryWhite,
        systemNavigationBarColor: AppColors.primaryWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // إعدادات الأزرار المرفوعة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlueViolet,
        foregroundColor: AppColors.primaryWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
    ),

    // إعدادات الأزرار المحددة
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlueViolet,
        side: BorderSide(color: AppColors.primaryBlueViolet, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
    ),

    // إعدادات البطاقات
    cardTheme: CardThemeData(
      color: AppColors.backgroundCard,
      elevation: 2,
      shadowColor: AppColors.primaryDark.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // إعدادات حقول الإدخال
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryBlueViolet, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        fontFamily: fontFamily,
      ),
      labelStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        fontFamily: fontFamily,
      ),
    ),

    dividerTheme: DividerThemeData(thickness: 1, color: AppColors.borderLight),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlueViolet,
      brightness: Brightness.light,
      primary: AppColors.primaryBlueViolet,
      secondary: AppColors.primaryTurquoise,
      surface: AppColors.backgroundCard,
      background: AppColors.backgroundPrimary,
      error: AppColors.primaryError,
      onPrimary: AppColors.primaryWhite,
      onSecondary: AppColors.primaryWhite,
      onSurface: AppColors.primaryDark,
      onBackground: AppColors.primaryDark,
      onError: AppColors.primaryWhite,
    ),
  );

  /// ثيم تطبيق المحفظ الداكن
  static ThemeData appDarkTheme(
    String fontFamily, {
    Color? scaffoldBackgroundColor,
  }) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: scaffoldBackgroundColor ?? AppColors.primaryDark,
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.primaryWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: AppColors.primaryDark,
        systemNavigationBarColor: AppColors.primaryDark,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlueViolet,
        foregroundColor: AppColors.primaryWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.primaryDark,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerTheme: DividerThemeData(
      thickness: 1,
      color: AppColors.textSecondary.withOpacity(0.3),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlueViolet,
      brightness: Brightness.dark,
      primary: AppColors.primaryBlueViolet,
      secondary: AppColors.primaryTurquoise,
      surface: AppColors.primaryDark,
      background: AppColors.primaryDark,
      error: AppColors.primaryError,
      onPrimary: AppColors.primaryWhite,
      onSecondary: AppColors.primaryWhite,
      onSurface: AppColors.primaryWhite,
      onBackground: AppColors.primaryWhite,
      onError: AppColors.primaryWhite,
    ),
  );
}
