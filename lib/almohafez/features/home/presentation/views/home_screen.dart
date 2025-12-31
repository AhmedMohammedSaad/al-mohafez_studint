import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/welcome_bar_widget.dart';
import '../widgets/banner_carousel_widget.dart';
import '../widgets/competitions_section_widget.dart';
import '../widgets/top_students_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Key to force rebuild of widgets that fetch data
  Key _refreshKey = UniqueKey();

  Future<void> _handleRefresh() async {
    // Artificial delay to show the refresh indicator
    await Future.delayed(const Duration(milliseconds: 1000));

    // Update the key to trigger a rebuild
    if (mounted) {
      setState(() {
        _refreshKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF0A1D64),
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
                          // Wrap with a KeyedSubtree or just pass the key if the widget accepted it.
                          // Since they don't, we can use a Container with a key or just rebuild the whole tree.
                          // A cleaner way is to key the widgets themselves if they are stateful or bloc providers.
                          // But since they are Stateless and create Blocs in build, checking if they are const
                          // might prevent rebuild. Let's force it by wrapping in a keyed widget.
                          KeyedSubtree(
                            key: _refreshKey,
                            child: Column(
                              children: [
                                const CompetitionsSectionWidget(),

                                SizedBox(height: 30.h),

                                // أفضل 10 طلاب
                                const TopStudentsWidget(),
                              ],
                            ),
                          ),

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
