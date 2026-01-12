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
            title: 'total_rate'.tr(),
            value: '${totalRate.toStringAsFixed(1)}%',
            icon: Icons.trending_up,
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }
}
