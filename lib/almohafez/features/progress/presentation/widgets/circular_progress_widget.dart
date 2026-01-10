import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CircularProgressWidget extends StatefulWidget {
  final double percentage;
  final Duration animationDuration;

  const CircularProgressWidget({
    super.key,
    required this.percentage,
    this.animationDuration = const Duration(seconds: 1),
  });

  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.percentage / 100.0)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w,
      height: 180.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 180.w,
            height: 180.w,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12.w,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFE5E5E5),
              ),
            ),
          ),
          // Animated progress circle
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: 180.w,
                height: 180.w,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 12.w,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF00E0FF),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              );
            },
          ),
          // Center text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    '${(_animation.value * 100).round()}%',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF202020),
                    ),
                  );
                },
              ),
              SizedBox(height: 4.h),
              Text(
                'progress_overall_label'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8C8C8C),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
