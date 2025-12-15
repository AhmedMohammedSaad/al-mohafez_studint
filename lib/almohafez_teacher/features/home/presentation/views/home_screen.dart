import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/welcome_bar_widget.dart';
import '../widgets/banner_carousel_widget.dart';
import '../widgets/quick_stats_widget.dart';
import '../widgets/sessions_overview_widget.dart';
import '../widgets/competitions_section_widget.dart';
import '../widgets/top_students_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // شريط الترحيب
                const WelcomeBarWidget(),

                SizedBox(height: 20.h),

                // البانر الإعلاني
                const BannerCarouselWidget(),

                SizedBox(height: 20.h),

                // الإحصائيات السريعة
                const QuickStatsWidget(),

                // SizedBox(height: 16.h),

                // نظرة عامة على الجلسات
                // const SessionsOverviewWidget(),
                SizedBox(height: 20.h),

                // قسم المسابقات
                const CompetitionsSectionWidget(),

                SizedBox(height: 30.h),

                // أفضل 10 طلاب
                const TopStudentsWidget(),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
