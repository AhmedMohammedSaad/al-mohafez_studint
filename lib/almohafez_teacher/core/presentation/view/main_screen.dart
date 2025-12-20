import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/utils/app_strings.dart';
import 'package:almohafez/almohafez_teacher/features/evaluations/presentation/views/evaluations_screen.dart';
import 'package:almohafez/almohafez_teacher/features/home/presentation/views/home_screen.dart';
import 'package:almohafez/almohafez_teacher/features/students/presentation/views/students_screen.dart';
import 'package:almohafez/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez_teacher/features/profile/presentation/views/profile_screen.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/views/sessions_screen.dart';

import '../../presentation/view/widgets/app_custom_image_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

Color navBackgroundColor = AppColors.secondary;
Color navActiveColor = AppColors.primaryColor2;
Color navInactiveColor = const Color(0xFF8A8A8A);

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  PersistentTabConfig _buildNavItem({
    required String iconPath,
    required Widget screen,
    required int index,
    required String label,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        icon: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return AppCustomImageView(
              imagePath: iconPath,
              color: AppColors.primaryBlueViolet,
            );
          },
        ),
        inactiveIcon: AppCustomImageView(
          imagePath: iconPath,
          color: AppColors.darkGreen100,
        ),
        title: label,
        textStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        activeForegroundColor: AppColors.primaryBlueViolet,
      ),
    );
  }

  List<PersistentTabConfig> _navBarsItems() {
    return [
      _buildNavItem(
        iconPath: AssetData.svgNavBarHome,
        screen: const HomeScreen(),
        index: 0,
        label: AppStrings.home,
      ),
      _buildNavItem(
        iconPath: AssetData.svgTeachersIcon, // Using teachers icon for students
        screen: const StudentsScreen(),
        index: 1,
        label: 'الطلاب',
      ),
      _buildNavItem(
        iconPath:
            AssetData.svgReservationIcon, // Using reservation icon for sessions
        screen: const SessionsScreen(),
        index: 2,
        label: 'الجلسات',
      ),
      _buildNavItem(
        iconPath: AssetData.svgReportIcon, // Using report icon for evaluations
        screen: const EvaluationsScreen(),
        index: 3,
        label: 'التقييمات',
      ),
      _buildNavItem(
        iconPath: AssetData.svgProfile,
        screen: const ProfileScreen(),
        index: 4,
        label: AppStrings.profile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);
    final ValueNotifier<int> previousIndexNotifier = ValueNotifier(0);

    final PersistentTabController bottomNavController = PersistentTabController(
      initialIndex: 0,
    );

    return SafeArea(
      bottom: true,
      left: false,
      right: false,
      top: false,

      child: Scaffold(
        key: scaffoldKey,
        body: PersistentTabView(
          navBarHeight: 70.h,
          //gestureNavigationEnabled: true,
          tabs: _navBarsItems(),
          controller: bottomNavController,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          popAllScreensOnTapAnyTabs: true,
          screenTransitionAnimation: const ScreenTransitionAnimation(
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: 200),
          ),
          onTabChanged: (index) async {
            previousIndexNotifier.value = currentIndexNotifier.value;
            currentIndexNotifier.value = index;
            bottomNavController.jumpToTab(index);
          },
          navBarBuilder: (navBarConfig) => Style7BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2), // Shadow direction
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
