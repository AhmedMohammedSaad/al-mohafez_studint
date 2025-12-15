import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/circular_progress_widget.dart';
import '../widgets/weekly_chart_widget.dart'; // Contains DailyChartWidget
import '../widgets/recent_sessions_widget.dart';
import '../widgets/teacher_notes_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../../data/models/progress_model.dart';
import '../../data/mock_data/progress_mock_data.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  ProgressModel? _progressData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProgressData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadProgressData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      // Use mock data for demonstration
      _progressData = ProgressMockData.getSampleData();
      _isLoading = false;
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'progress_title'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'progress_subtitle'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8C8C8C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E0FF)),
        ),
      );
    }

    if (_progressData == null || _progressData!.hasError) {
      return EmptyStateWidget(
        message: _progressData?.errorMessage ?? 'progress_loading_error'.tr(),
        subtitle: 'progress_loading_error_subtitle'.tr(),
        icon: Icons.error_outline,
      );
    }

    if (_progressData!.isEmpty) {
      return EmptyStateWidget(
        message: 'progress_empty_message'.tr(),
        subtitle: 'progress_empty_subtitle'.tr(),
        icon: Icons.analytics_outlined,
      );
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
            child: _buildProgressContent(),
          ),
        );
      },
    );
  }

  Widget _buildProgressContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Overall Progress Circle
            CircularProgressWidget(percentage: _progressData!.overallProgress),
            SizedBox(height: 24.h),

            // Daily Performance Chart
            DailyChartWidget(
              dailyData: _progressData!.dailyPerformance,
              height: 250,
            ),
            SizedBox(height: 24.h),

            // Recent Sessions
            RecentSessionsWidget(sessions: _progressData!.recentSessions),
            SizedBox(height: 24.h),

            // Teacher Notes
            TeacherNotesWidget(notes: _progressData!.teacherNotes),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
