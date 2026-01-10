import 'package:almohafez/almohafez/core/utils/app_strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:almohafez/generated/assets.dart';
import '../../theme/app_colors.dart';
import 'widgets/app_custom_image_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/modern_bottom_nav_bar.dart';
import '../../../features/home/presentation/views/home_screen.dart';
import '../../../features/teachers/presentation/views/teachers_screen.dart';
import '../../../features/sessions/presentation/views/sessions_screen.dart';
import '../../../features/progress/presentation/views/progress_screen.dart';
import '../../../features/profile/presentation/views/profile_screen.dart';

Color navBackgroundColor = AppColors.secondary;
Color navActiveColor = AppColors.primaryColor2;
Color navInactiveColor = const Color(0xFF8A8A8A);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  late PersistentTabController _bottomNavController;

  @override
  void initState() {
    super.initState();
    _bottomNavController = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _bottomNavController.dispose();
    super.dispose();
  }

  PersistentTabConfig _buildNavItem({
    required String iconPath,
    required Widget screen,
    required int index,
    required String label,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        icon: AppCustomImageView(
          imagePath: iconPath,
          color: AppColors.primaryBlueViolet,
        ),
        inactiveIcon: AppCustomImageView(
          imagePath: iconPath,
          color: AppColors.darkGreen100,
        ),
        title: label,
        textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
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
        iconPath: AssetData.svgTeachersIcon, // Using   icon for teachers
        screen: const TeachersScreen(),
        index: 1,
        label: 'nav_teachers'.tr(),
      ),
      _buildNavItem(
        iconPath:
            AssetData.svgReservationIcon, // Using reservation icon for sessions
        screen: const SessionsScreen(),
        index: 2,
        label: 'nav_sessions'.tr(),
      ),
      _buildNavItem(
        iconPath: AssetData.svgReportIcon, // Using report icon for progress
        screen: const ProgressScreen(),
        index: 3,
        label: 'nav_progress'.tr(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: SafeArea(
        bottom: true,
        left: false,
        right: false,
        top: false,
        child: PersistentTabView(
          navBarHeight: 80.h,
          //gestureNavigationEnabled: true,
          tabs: _navBarsItems(),
          controller: _bottomNavController,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          popAllScreensOnTapAnyTabs: true,
          screenTransitionAnimation: const ScreenTransitionAnimation(
            curve: Curves.easeInOutQuart,
            duration: Duration(milliseconds: 500),
          ),
          onTabChanged: (index) async {
            _bottomNavController.jumpToTab(index);
          },
          navBarBuilder: (navBarConfig) => ModernBottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(170, 158, 158, 158),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Shadow direction
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
