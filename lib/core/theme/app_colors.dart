import 'package:flutter/material.dart';

import '../utils/app_consts.dart';

class AppColors {
  // ========== ألوان تطبيق المحفظ الأساسية ==========

  // الأزرق البنفسجي الأساسي - لون الهوية الرئيسي
  static Color get primaryBlueViolet =>
      AppConst.isDark ? const Color(0xFF6366F1) : const Color(0xFF6366F1);

  // التركواز الأساسي - لون الهوية الثانوي
  static Color get primaryTurquoise =>
      AppConst.isDark ? const Color(0xFF06B6D4) : const Color(0xFF06B6D4);

  // الأبيض النقي - للخلفيات والنصوص
  static Color get primaryWhite =>
      AppConst.isDark ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);

  // الرمادي الداكن - للنصوص الأساسية
  static Color get primaryDark =>
      AppConst.isDark ? const Color(0xFF1F2937) : const Color(0xFF1F2937);

  // الذهبي الفاتح - للإنجازات والمكافآت
  static Color get primaryGold =>
      AppConst.isDark ? const Color(0xFFFBBF24) : const Color(0xFFFBBF24);

  // الأخضر للنجاح والإنجازات
  static Color get primarySuccess =>
      AppConst.isDark ? const Color(0xFF10B981) : const Color(0xFF10B981);

  // الأحمر للتحذيرات والأخطاء
  static Color get primaryError =>
      AppConst.isDark ? const Color(0xFFEF4444) : const Color(0xFFEF4444);

  // خلفية التطبيق الرئيسية
  static Color get backgroundPrimary =>
      AppConst.isDark ? const Color(0xFFF8FAFC) : const Color(0xFFF8FAFC);

  // خلفية البطاقات والعناصر
  static Color get backgroundCard =>
      AppConst.isDark ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);

  // ========== تدرجات الأزرق البنفسجي ==========
  static Color get blueViolet50 =>
      AppConst.isDark ? const Color(0xFFF0F0FF) : const Color(0xFFF0F0FF);
  static Color get blueViolet100 =>
      AppConst.isDark ? const Color(0xFFE0E7FF) : const Color(0xFFE0E7FF);
  static Color get blueViolet200 =>
      AppConst.isDark ? const Color(0xFFC7D2FE) : const Color(0xFFC7D2FE);
  static Color get blueViolet300 =>
      AppConst.isDark ? const Color(0xFFA5B4FC) : const Color(0xFFA5B4FC);
  static Color get blueViolet400 =>
      AppConst.isDark ? const Color(0xFF818CF8) : const Color(0xFF818CF8);
  static Color get blueViolet500 =>
      AppConst.isDark ? const Color(0xFF6366F1) : const Color(0xFF6366F1);
  static Color get blueViolet600 =>
      AppConst.isDark ? const Color(0xFF4F46E5) : const Color(0xFF4F46E5);
  static Color get blueViolet700 =>
      AppConst.isDark ? const Color(0xFF4338CA) : const Color(0xFF4338CA);
  static Color get blueViolet800 =>
      AppConst.isDark ? const Color(0xFF3730A3) : const Color(0xFF3730A3);
  static Color get blueViolet900 =>
      AppConst.isDark ? const Color(0xFF312E81) : const Color(0xFF312E81);

  // ========== تدرجات التركواز ==========
  static Color get turquoise50 =>
      AppConst.isDark ? const Color(0xFFECFEFF) : const Color(0xFFECFEFF);
  static Color get turquoise100 =>
      AppConst.isDark ? const Color(0xFFCFFAFE) : const Color(0xFFCFFAFE);
  static Color get turquoise200 =>
      AppConst.isDark ? const Color(0xFFA5F3FC) : const Color(0xFFA5F3FC);
  static Color get turquoise300 =>
      AppConst.isDark ? const Color(0xFF67E8F9) : const Color(0xFF67E8F9);
  static Color get turquoise400 =>
      AppConst.isDark ? const Color(0xFF22D3EE) : const Color(0xFF22D3EE);
  static Color get turquoise500 =>
      AppConst.isDark ? const Color(0xFF06B6D4) : const Color(0xFF06B6D4);
  static Color get turquoise600 =>
      AppConst.isDark ? const Color(0xFF0891B2) : const Color(0xFF0891B2);
  static Color get turquoise700 =>
      AppConst.isDark ? const Color(0xFF0E7490) : const Color(0xFF0E7490);
  static Color get turquoise800 =>
      AppConst.isDark ? const Color(0xFF155E75) : const Color(0xFF155E75);
  static Color get turquoise900 =>
      AppConst.isDark ? const Color(0xFF164E63) : const Color(0xFF164E63);

  // ========== ألوان إضافية للتطبيق الإسلامي ==========

  // الأخضر الإسلامي التقليدي
  static Color get islamicGreen =>
      AppConst.isDark ? const Color(0xFF059669) : const Color(0xFF059669);

  // البني الذهبي للزخارف
  static Color get goldenBrown =>
      AppConst.isDark ? const Color(0xFFD97706) : const Color(0xFFD97706);

  // الرمادي الفاتح للنصوص الثانوية
  static Color get textSecondary =>
      AppConst.isDark ? const Color(0xFF6B7280) : const Color(0xFF6B7280);

  // الرمادي الفاتح جداً للحدود
  static Color get borderLight =>
      AppConst.isDark ? const Color(0xFFE5E7EB) : const Color(0xFFE5E7EB);

  // خلفية فاتحة للأقسام
  static Color get backgroundSection =>
      AppConst.isDark ? const Color(0xFFF9FAFB) : const Color(0xFFF9FAFB);

  // ========== الألوان القديمة (للتوافق مع الكود الموجود) ==========

  // Main Green Shades
  static Color get mainGreen50 =>
      AppConst.isDark ? const Color(0xFFF8FFF2) : const Color(0xFFF8FFF2);
  static Color get mainGray880 =>
      AppConst.isDark ? const Color(0xFF50555C) : const Color(0xFF50555C);
  static Color get mainGreen100 =>
      AppConst.isDark ? const Color(0xFFF3FDD5) : const Color(0xFFF3FDD5);
  static Color get mainGreen200 =>
      AppConst.isDark ? const Color(0xFFEEFDC1) : const Color(0xFFEEFDC1);
  static Color get mainGreen300 =>
      AppConst.isDark ? const Color(0xFFE6FCA5) : const Color(0xFFE6FCA5);
  static Color get mainGreen400 =>
      AppConst.isDark ? const Color(0xFFE8F893) : const Color(0xFFE8F893);
  static Color get mainGreen500 =>
      AppConst.isDark ? const Color(0xFFD9FA78) : const Color(0xFFD9FA78);
  static Color get mainGreen600 =>
      AppConst.isDark ? const Color(0xFFC5E64D) : const Color(0xFFC5E64D);
  static Color get mainGreen700 =>
      AppConst.isDark ? const Color(0xFF9AB255) : const Color(0xFF9AB255);
  static Color get mainGreen800 =>
      AppConst.isDark ? const Color(0xFF778AA2) : const Color(0xFF778AA2);
  static Color get mainGreen900 =>
      AppConst.isDark ? const Color(0xFF5B6932) : const Color(0xFF5B6932);

  // Dark Green Shades
  static Color get darkGreen50 =>
      AppConst.isDark ? const Color(0xFFE6EBEA) : const Color(0xFFE6EBEA);
  static Color get darkGreen100 =>
      AppConst.isDark ? const Color(0xFFB2BFBD) : const Color(0xFFB2BFBD);
  static Color get darkGreen200 =>
      AppConst.isDark ? const Color(0xFF8DA190) : const Color(0xFF8DA190);
  static Color get darkGreen300 =>
      AppConst.isDark ? const Color(0xFF5A7670) : const Color(0xFF5A7670);
  static Color get darkGreen400 =>
      AppConst.isDark ? const Color(0xFF395B55) : const Color(0xFF395B55);
  static Color get darkGreen500 =>
      AppConst.isDark ? const Color(0xFF08322A) : const Color(0xFF08322A);
  static Color get darkGreen600 =>
      AppConst.isDark ? const Color(0xFF072E26) : const Color(0xFF072E26);
  static Color get darkGreen700 =>
      AppConst.isDark ? const Color(0xFF062A1E) : const Color(0xFF062A1E);
  static Color get darkGreen800 =>
      AppConst.isDark ? const Color(0xFF0A1C17) : const Color(0xFF0A1C17);
  static Color get darkGreen900 =>
      AppConst.isDark ? const Color(0xFF031512) : const Color(0xFF031512);

  // Secondary Green Shades
  static Color get secondaryGreen50 =>
      AppConst.isDark ? const Color(0xFFFDFFF9) : const Color(0xFFFDFFF9);
  static Color get secondaryGreen100 =>
      AppConst.isDark ? const Color(0xFFF9FDEB) : const Color(0xFFF9FDEB);
  static Color get secondaryGreen200 =>
      AppConst.isDark ? const Color(0xFFF6FCE2) : const Color(0xFFF6FCE2);
  static Color get secondaryGreen300 =>
      AppConst.isDark ? const Color(0xFFF2FBD4) : const Color(0xFFF2FBD4);
  static Color get secondaryGreen400 =>
      AppConst.isDark ? const Color(0xFFF0FACC) : const Color(0xFFF0FACC);
  static Color get secondaryGreen500 =>
      AppConst.isDark ? const Color(0xFFECF9BF) : const Color(0xFFECF9BF);
  static Color get secondaryGreen600 =>
      AppConst.isDark ? const Color(0xFFD7E3AE) : const Color(0xFFD7E3AE);
  static Color get secondaryGreen700 =>
      AppConst.isDark ? const Color(0xFFA8B1B8) : const Color(0xFFA8B1B8);
  static Color get secondaryGreen800 =>
      AppConst.isDark ? const Color(0xFF82B969) : const Color(0xFF82B969);
  static Color get secondaryGreen900 =>
      AppConst.isDark ? const Color(0xFF636950) : const Color(0xFF636950);

  // Secondary Purple Shades
  static Color get secondaryPurple50 =>
      AppConst.isDark ? const Color(0xFFF9F9FD) : const Color(0xFFF9F9FD);
  static Color get secondaryPurple100 =>
      AppConst.isDark ? const Color(0xFFEBECF9) : const Color(0xFFEBECF9);
  static Color get secondaryPurple200 =>
      AppConst.isDark ? const Color(0xFFE1E3F6) : const Color(0xFFE1E3F6);
  static Color get secondaryPurple300 =>
      AppConst.isDark ? const Color(0xFFD3D6F2) : const Color(0xFFD3D6F2);
  static Color get secondaryPurple400 =>
      AppConst.isDark ? const Color(0xFFCBC1EF) : const Color(0xFFCBC1EF);
  static Color get secondaryPurple500 =>
      AppConst.isDark ? const Color(0xFF8EC2EB) : const Color(0xFF8EC2EB);
  static Color get secondaryPurple600 =>
      AppConst.isDark ? const Color(0xFFADB1D6) : const Color(0xFFADB1D6);
  static Color get secondaryPurple700 =>
      AppConst.isDark ? const Color(0xFF878AA7) : const Color(0xFF878AA7);
  static Color get secondaryPurple800 =>
      AppConst.isDark ? const Color(0xFF696B81) : const Color(0xFF696B81);
  static Color get secondaryPurple900 =>
      AppConst.isDark ? const Color(0xFF503163) : const Color(0xFF503163);

  // Main Black Shades
  static Color get mainBlack50 =>
      AppConst.isDark ? const Color(0xFFE7E7E7) : const Color(0xFFE7E7E7);
  static Color get mainBlack100 =>
      AppConst.isDark ? const Color(0xFFB4B4B4) : const Color(0xFFB4B4B4);
  static Color get mainBlack200 =>
      AppConst.isDark ? const Color(0xFF909090) : const Color(0xFF909090);
  static Color get mainBlack300 =>
      AppConst.isDark ? const Color(0xFF5E5E5E) : const Color(0xFF5E5E5E);
  static Color get mainBlack400 =>
      AppConst.isDark ? const Color(0xFF3E3E3E) : const Color(0xFF3E3E3E);
  static Color get mainBlack500 =>
      AppConst.isDark ? const Color(0xFF0E0E0E) : const Color(0xFF0E0E0E);
  static Color get mainBlack600 =>
      AppConst.isDark ? const Color(0xFF0D0D0D) : const Color(0xFF0D0D0D);
  static Color get mainBlack700 =>
      AppConst.isDark ? const Color(0xFF0B0B0B) : const Color(0xFF0B0B0B);
  static Color get mainBlack800 =>
      AppConst.isDark ? const Color(0xFF080808) : const Color(0xFF080808);
  static Color get mainBlack900 =>
      AppConst.isDark ? const Color(0xFF060606) : const Color(0xFF060606);

  // Main White Shades
  static Color get mainWhite50 =>
      AppConst.isDark ? const Color(0xFFFDFDFD) : const Color(0xFFFDFDFD);
  static Color get mainWhite100 =>
      AppConst.isDark ? const Color(0xFFF7F7F7) : const Color(0xFFF7F7F7);
  static Color get mainWhite200 =>
      AppConst.isDark ? const Color(0xFFF4F4F4) : const Color(0xFFF4F4F4);
  static Color get mainWhite300 =>
      AppConst.isDark ? const Color(0xFFEEEEEE) : const Color(0xFFEEEEEE);
  static Color get mainWhite400 =>
      AppConst.isDark ? const Color(0xFFEBEBEB) : const Color(0xFFEBEBEB);
  static Color get mainWhite500 =>
      AppConst.isDark ? const Color(0xFFE6E6E6) : const Color(0xFFE6E6E6);
  static Color get mainWhite600 =>
      AppConst.isDark ? const Color(0xFFD1D1D1) : const Color(0xFFD1D1D1);
  static Color get mainWhite700 =>
      AppConst.isDark ? const Color(0xFFA3A3A3) : const Color(0xFFA3A3A3);
  static Color get mainWhite800 =>
      AppConst.isDark ? const Color(0xFF7F7F7F) : const Color(0xFF7F7F7F);
  static Color get mainWhite900 =>
      AppConst.isDark ? const Color(0xFF616161) : const Color(0xFF616161);
  static Color get mainBackground =>
      AppConst.isDark ? const Color(0xFFF6F6F6) : const Color(0xFFF6F6F6);

  ///
  static Color get background => AppConst.isDark ? mainBlack900 : mainWhite50;
  static Color get label => AppConst.isDark ? mainWhite50 : darkGreen500;
  static Color get primary => AppConst.isDark ? primaryBlueViolet : primaryDark;

  /// default colors
  static Color get hint =>
      AppConst.isDark ? const Color(0xFF6D7986) : const Color(0xFF8A8A8A);
  static Color get transparent => Colors.transparent;
  static Color get success => const Color(0xFF117013);
  static Color get warning => const Color(0xffF4B400);
  static Color get error => const Color(0xffDD3131);

  /// Old colors
  static Color get primaryColor2 => AppConst.isDark
      ? const Color(0xff781504)
      : const Color(0xff781504); // Dark teal
  static Color get orange => AppConst.isDark
      ? const Color(0xFFFB6F3D)
      : const Color(0xFFFB6F3D); // Dark teal
  static Color get indigo => AppConst.isDark
      ? const Color(0xFF413DFB)
      : const Color(0xFF413DFB); // Dark teal
  static Color get purple => AppConst.isDark
      ? const Color(0xFFB33DFB)
      : const Color(0xFFB33DFB); // Dark teal
  static Color get blue700 => AppConst.isDark
      ? const Color(0xFF1E497E)
      : const Color(0xFF3DFFD0); // Mint green
  static Color get iconBackGround =>
      AppConst.isDark ? const Color(0xFF1F2226) : const Color(0xFFF2F4F4);
  static Color get tagColor => AppConst.isDark
      ? const Color(0xFFFFD700)
      : const Color(0xFFFF6B6B); // Coral red
  static Color get yellowDark => AppConst.isDark
      ? const Color(0xFFFFAA2A)
      : const Color(0xFFFFAA2A); // Spring green
  static Color get link =>
      AppConst.isDark ? const Color(0xFF6AAFE6) : const Color(0xFF49709C);
  static Color get infoCardBorder =>
      AppConst.isDark ? const Color(0xFF404D5C) : const Color(0xFFCEDAE8);
  static Color get red =>
      AppConst.isDark ? const Color(0xFFFF4444) : const Color(0xFFFF0000);
  static Color get buttonColor =>
      AppConst.isDark ? const Color(0xFF073B4C) : const Color(0xFF073B4C);
  static Color get tabColor =>
      AppConst.isDark ? const Color(0xFF073B4C) : const Color(0x073B4C4D);
  static Color get cardColor =>
      AppConst.isDark ? const Color(0xFF073B4C) : const Color(0xFFF2F2F2);

  static Color get inActiveNavBarColor =>
      AppConst.isDark ? const Color(0xFF5A6373) : const Color(0xFF74829C);
  static Color get grey =>
      AppConst.isDark ? const Color(0xFFCBD5E1) : const Color(0xFFCBD5E1);
  static Color get grey1 =>
      AppConst.isDark ? const Color(0xFFF6F8FA) : const Color(0xFFF6F8FA);
  static Color get border =>
      AppConst.isDark ? const Color(0xFF2A2A3E) : const Color(0xFFEEF7FF);
  static Color get black900 =>
      AppConst.isDark ? const Color(0xFFFAFAFA) : const Color(0xFF04021D);
  static Color get lightTeal =>
      AppConst.isDark ? const Color(0xFF7FFFD4) : const Color(0xFF7FFFD4);
  static Color get white =>
      AppConst.isDark ? const Color(0xFF131921) : Colors.white;
  static Color get blackConstant => Colors.black;

  static Color get primaryColorChanged =>
      AppConst.isDark ? const Color(0xff232F3E) : const Color(0xff116ACC);
  static Color get roomChatBackGround =>
      AppConst.isDark ? const Color(0xFF232F3E) : const Color(0xff3F72AF);
  static Color get secondary =>
      AppConst.isDark ? const Color(0xff4B5563) : const Color(0xff182233);
  static Color get secondary2 => AppConst.isDark
      ? const Color.fromRGBO(255, 255, 255, 0.87)
      : const Color(0xff182233);
  static const Color secondaryConstant = Color(0xff182233);

  static Color hubRefactoredBG = AppConst.isDark
      ? const Color(0xff171717)
      : black;
  static Color get darkGray => AppConst.isDark
      ? const Color.fromRGBO(255, 255, 255, 0.87)
      : const Color(0xff6B7280);
  // Add darkGray2 color
  static Color get darkGray2 => AppConst.isDark
      ? const Color.fromRGBO(255, 255, 255, 0.60)
      : const Color(0xff9CA3AF);
  static const Color darkGray2Constant = Color(0xff9CA3AF);

  static const Color darkGrayConstant = Color(0xff6B7280);
  Color get lightGray => AppConst.isDark
      ? const Color(0xff232F3E)
      : const Color(0xFFE8E8E8); // Light gray from image
  static Color get lightGray2 => AppConst.isDark
      ? const Color(0xff131921)
      : const Color(0xFFF5F5F5); // Lighter gray from image
  static const Color lightGrayConstant = Color(0xffEEEEEE);
  static const Color darkGreenConstant = Color(0xff003C00);
  static const Color darkPurpleConstant = Color(0xff32045D);

  static Color get black => AppConst.isDark
      ? const Color.fromRGBO(255, 255, 255, 0.87)
      : Colors.black;
  static Color get black2 =>
      AppConst.isDark ? const Color(0xff131921) : Colors.black;
  static Color get hubBGColor => AppConst.isDark ? Colors.black : Colors.white;
  static const Color whiteConstant = Colors.white;
  static const Color cyanConstant = Color(0xff2A629A);
  static const Color blue = Colors.blue;
  static const Color grayTextForm = Color(0xffC2C2C2);
  static const Color gradientColor1 = Color(0xff3F97F9);
  static const Color gradientColor2 = Color(0xff116ACC);
  static const Color greenColor = Colors.green;
  static Color onFocusColor = Colors.blue.shade200;

  static const Color darkYellowConstant = Color(0xff754D09);
  static const Color darkRedConstant = Color(0xff781504);

  static Color get gray2 =>
      AppConst.isDark ? const Color(0xff6B7280) : const Color(0xff374151);
  static Color get gray6 =>
      AppConst.isDark ? const Color(0xff232F3E) : const Color(0xffD1D5DB);
  static Color get gray3 =>
      AppConst.isDark ? const Color(0xff2688EB) : const Color(0xFF6D7885);
  static Color get gray6Static => const Color(0xff232F3E);
  static Color get gray8 =>
      AppConst.isDark ? const Color(0xff1D2632) : const Color(0xffECEDF1);
  static const Color gray6Constant = Color(0xffD1D5DB);
  static Color get gray7 =>
      AppConst.isDark ? const Color(0xff232F3E) : const Color(0xffF3F4F6);
  static Color get gray =>
      AppConst.isDark ? const Color(0xffF2F2F2) : const Color(0xffF2F2F2);
  static Color get grayApp =>
      AppConst.isDark ? const Color(0xffACACAC) : const Color(0xffACACAC);
  static Color get chipFilterColor =>
      AppConst.isDark ? const Color(0xFFEAEAEA) : const Color(0xFFEAEAEA);
  static Color get borderSearchField =>
      AppConst.isDark ? const Color(0xFFD9D9D9) : const Color(0xFFD9D9D9);

  static const Color disable = Color(0xff9CA3AF);

  static const Color splashBackGround = Color(0xff182233);

  static const Color dotColor = Color(0x80116ACC);
  static const Color newGray = Color(0xff6D7885);
  static const Color brandyPunch = Color(0xFFAE8160);
  static const Color brandyPunchLight = Color(0xFFFFE5BE);
  static const Color brandyPunchLight2 = Color(0xFFFFF7ED);
  static const Color formFieldColor = Color(0x14397EF6);
  static const Color textSecondryColor = Color(0xFF939393);
}
