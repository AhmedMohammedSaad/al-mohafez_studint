import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ModernBottomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  const ModernBottomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color:
            navBarDecoration.color ?? const Color.fromARGB(255, 198, 218, 231),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow:
            navBarDecoration.boxShadow ??
            [
              BoxShadow(
                color: Colors.black,
                blurRadius: 30,
                offset: const Offset(0, 5),
                spreadRadius: 1,
                blurStyle: BlurStyle.inner,
              ),
            ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navBarConfig.items.length, (index) {
            final item = navBarConfig.items[index];
            final isSelected = index == navBarConfig.selectedIndex;

            return InkWell(
              onTap: () {
                navBarConfig.onItemSelected(index);
              },
              borderRadius: BorderRadius.circular(20.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16.w : 10.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xffEEF2F6) // Light background for active
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 1.0,
                        end: isSelected ? 1.2 : 1.0,
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: IconTheme(
                        data: IconThemeData(
                          size: 24.sp,
                          color: isSelected
                              ? AppColors.primaryBlueViolet
                              : AppColors.textSecondary,
                        ),
                        child: isSelected ? item.icon : item.inactiveIcon,
                      ),
                    ),

                    if (isSelected) 5.width,
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: 0),
                      secondChild: Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: Text(
                          item.title ?? '',
                          style: TextStyle(
                            color: AppColors.primaryBlueViolet,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.sp,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      crossFadeState: isSelected
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                      firstCurve: Curves.easeInOut,
                      secondCurve: Curves.easeInOut,
                      sizeCurve: Curves.easeInOut,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
