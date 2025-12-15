import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'statistic_card_widget.dart';

class StatisticsCardsWidget extends StatelessWidget {
  const StatisticsCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatisticCardWidget(
            title: 'profile_sessions_count'.tr(),
            value: '24',
            icon: Icons.video_call,
            color: const Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatisticCardWidget(
            title: 'profile_photos_count'.tr(),
            value: '156',
            icon: Icons.photo_library,
            color: const Color(0xFF3B82F6),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatisticCardWidget(
            title: 'profile_attendance_rate'.tr(),
            value: '92%',
            icon: Icons.trending_up,
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }
}