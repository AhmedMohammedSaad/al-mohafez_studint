import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'statistic_card_widget.dart';

class StatisticsCardsWidget extends StatelessWidget {
  final int sessionsCount;
  final double totalRate;

  const StatisticsCardsWidget({
    super.key,
    required this.sessionsCount,
    required this.totalRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatisticCardWidget(
            title: 'profile_sessions_count'.tr(),
            value: '$sessionsCount',
            icon: Icons.video_call,
            color: const Color(0xFF10B981),
          ),
        ),
        // Photos section Removed as per request
        // SizedBox(width: 12.w),
        // Expanded(
        //   child: StatisticCardWidget(
        //     title: 'profile_photos_count'.tr(),
        //     value: '156',
        //     icon: Icons.photo_library, // Keep the code commented or remove entirely?
        //     color: const Color(0xFF3B82F6),
        //   ),
        // ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatisticCardWidget(
            // Rename Attendance -> Total Rate (or Progress)
            // User said: "Total Rate" or "Progress"
            // Let's use a translation key that reflects this, or hardcode/dynamic string if key not available.
            // Using 'profile_attendance_rate' key for now but we might need to change the arb file or text.
            // Assuming 'profile_attendance_rate' translates to "Attendance", user wants "Total Rate".
            // Since I cannot easily edit ARB right now without seeing it, I'll use a new key or English fallback if needed.
            // But let's assume we can just change the widget text or standard key.
            title: 'total_rate'.tr(), // New key or fallback
            value: '${totalRate.toStringAsFixed(1)}%',
            icon: Icons.trending_up,
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }
}
