import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SessionTimerWidget extends StatefulWidget {
  final bool isActive;
  final Duration duration;
  final Function(Duration) onDurationChanged;

  const SessionTimerWidget({
    super.key,
    required this.isActive,
    required this.duration,
    required this.onDurationChanged,
  });

  @override
  State<SessionTimerWidget> createState() => _SessionTimerWidgetState();
}

class _SessionTimerWidgetState extends State<SessionTimerWidget>
    with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(SessionTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startTimer();
        _pulseController.repeat(reverse: true);
      } else {
        _stopTimer();
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      widget.onDurationChanged(widget.duration + const Duration(seconds: 1));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // عنوان المؤقت
          Text(
            'مؤقت الجلسة',
            style: AppTextStyle.textStyle18Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 20.h),

          // المؤقت الرئيسي
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isActive ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isActive
                          ? [
                              AppColors.primaryBlueViolet,
                              AppColors.primaryBlueViolet.withOpacity(0.7),
                            ]
                          : [
                              AppColors.textSecondary.withOpacity(0.3),
                              AppColors.textSecondary.withOpacity(0.1),
                            ],
                    ),
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primaryBlueViolet.withOpacity(
                                0.3,
                              ),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 0),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatDuration(widget.duration),
                          style: AppTextStyle.textStyle32Bold.copyWith(
                            color: widget.isActive
                                ? AppColors.primaryBlueViolet
                                : AppColors.textPrimary,
                            fontSize: 48.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.isActive ? 'جارية' : 'متوقفة',
                          style: AppTextStyle.textStyle14Medium.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 20.h),

          // معلومات إضافية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoCard(
                'الدقائق',
                widget.duration.inMinutes.toString(),
                Icons.access_time_rounded,
                AppColors.primarySuccess,
              ),
              _buildInfoCard(
                'الثواني',
                (widget.duration.inSeconds % 60).toString(),
                Icons.timer_rounded,
                AppColors.primaryWarning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.sp, color: color),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyle.textStyle16Bold.copyWith(color: color),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTextStyle.textStyle12Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
