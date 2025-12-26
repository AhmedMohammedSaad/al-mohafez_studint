import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/circular_progress_widget.dart';
import '../widgets/weekly_chart_widget.dart';
import '../widgets/recent_sessions_widget.dart';
import '../widgets/teacher_notes_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../../data/repos/progress_repo.dart';
import '../cubit/progress_cubit.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressCubit(ProgressRepo())..loadProgressData(),
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatefulWidget {
  const _ProgressView();

  @override
  State<_ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<_ProgressView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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
      width: double.infinity,
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
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E0FF)),
            ),
          );
        }

        if (state is ProgressError) {
          return EmptyStateWidget(
            message: state.message,
            subtitle: 'progress_loading_error_subtitle'.tr(),
            icon: Icons.error_outline,
            // onRetry: () => context.read<ProgressCubit>().loadProgressData(),
          );
        }

        if (state is ProgressLoaded) {
          final progressData = state.progressData;

          // Trigger animation when loaded
          _fadeController.forward();

          if (progressData.isEmpty) {
            return EmptyStateWidget(
              message: 'progress_empty_message'.tr(),
              subtitle: 'progress_empty_subtitle'.tr(),
              icon: Icons.analytics_outlined,
              //  () => context.read<ProgressCubit>().loadProgressData(),
            );
          }

          return AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                  child: _buildProgressContent(progressData),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProgressContent(progressData) {
    return RefreshIndicator(
      onRefresh: () => context.read<ProgressCubit>().loadProgressData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Overall Progress Circle
              CircularProgressWidget(percentage: progressData.overallProgress),
              SizedBox(height: 24.h),

              // Daily Performance Chart
              DailyChartWidget(
                dailyData: progressData.dailyPerformance,
                height: 250,
              ),
              SizedBox(height: 24.h),

              // Recent Sessions
              RecentSessionsWidget(sessions: progressData.recentSessions),
              SizedBox(height: 24.h),

              // Teacher Notes
              TeacherNotesWidget(notes: progressData.teacherNotes),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
