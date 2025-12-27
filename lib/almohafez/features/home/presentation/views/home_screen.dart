import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/welcome_bar_widget.dart';
import '../widgets/banner_carousel_widget.dart';
import '../widgets/competitions_section_widget.dart';
import '../widgets/top_students_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    [
                          SizedBox(height: 12.h),

                          // شريط الترحيب
                          const WelcomeBarWidget(),

                          SizedBox(height: 20.h),

                          // البانر الإعلاني
                          const BannerCarouselWidget(),

                          SizedBox(height: 24.h),

                          // قسم المسابقات
                          const CompetitionsSectionWidget(),

                          SizedBox(height: 30.h),

                          // أفضل 10 طلاب
                          const TopStudentsWidget(),

                          SizedBox(height: 20.h),
                        ]
                        .animate(interval: 100.ms)
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
