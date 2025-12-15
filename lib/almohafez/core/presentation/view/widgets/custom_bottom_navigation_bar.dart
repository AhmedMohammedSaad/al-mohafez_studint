import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<AnimationController> _pressAnimationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _pressScaleAnimations;

  List<BottomNavItem> get _navItems => [
    BottomNavItem(
      icon: Icons.home_rounded,
      label: 'nav_home'.tr(),
      activeColor: const Color(0xFF00E0FF),
      inactiveColor: const Color(0xFF9EA8C5),
    ),
    BottomNavItem(
      icon: Icons.school_rounded,
      label: 'nav_teachers'.tr(),
      activeColor: const Color(0xFF00E0FF),
      inactiveColor: const Color(0xFF9EA8C5),
    ),
    BottomNavItem(
      icon: Icons.video_call_rounded,
      label: 'nav_sessions'.tr(),
      activeColor: const Color(0xFF00E0FF),
      inactiveColor: const Color(0xFF9EA8C5),
    ),
    BottomNavItem(
      icon: Icons.bar_chart_rounded,
      label: 'nav_progress'.tr(),
      activeColor: const Color(0xFF00E0FF),
      inactiveColor: const Color(0xFF9EA8C5),
    ),
    BottomNavItem(
      icon: Icons.person_rounded,
      label: 'nav_profile'.tr(),
      activeColor: const Color(0xFF00E0FF),
      inactiveColor: const Color(0xFF9EA8C5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _pressAnimationControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers
        .map(
          (controller) => Tween<double>(begin: 1.0, end: 1.05).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();

    _pressScaleAnimations = _pressAnimationControllers
        .map(
          (controller) => Tween<double>(begin: 1.0, end: 1.15).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();

    // Set initial active state
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Reset previous animation
      if (oldWidget.currentIndex < _animationControllers.length) {
        _animationControllers[oldWidget.currentIndex].reverse();
      }
      // Start new animation
      if (widget.currentIndex < _animationControllers.length) {
        _animationControllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    for (var controller in _pressAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isActive = widget.currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.onTap(index);
                },
                onTapDown: (_) {
                  _pressAnimationControllers[index].forward();
                },
                onTapUp: (_) {
                  _pressAnimationControllers[index].reverse();
                },
                onTapCancel: () {
                  _pressAnimationControllers[index].reverse();
                },
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _scaleAnimations[index],
                    _pressScaleAnimations[index],
                  ]),
                  builder: (context, child) {
                    double combinedScale =
                        _scaleAnimations[index].value *
                        _pressScaleAnimations[index].value;
                    return Transform.scale(
                      scale: combinedScale,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                item.icon,
                                size: 22.sp,
                                color: isActive
                                    ? item.activeColor
                                    : item.inactiveColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Flexible(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: isActive ? 11.sp : 10.sp,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isActive
                                      ? item.activeColor
                                      : item.inactiveColor,
                                ),
                                child: Text(
                                  item.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isActive ? 20.w : 0,
                              height: isActive ? 2.h : 0,
                              decoration: BoxDecoration(
                                color: item.activeColor,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.inactiveColor,
  });
}
