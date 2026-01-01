import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/cubit/sessions_cubit.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/cubit/sessions_state.dart';
import 'package:almohafez/almohafez_teacher/features/students/presentation/cubit/teacher_students_cubit.dart';
import 'package:almohafez/almohafez_teacher/features/students/presentation/cubit/teacher_students_state.dart';
import 'package:shimmer/shimmer.dart';

class QuickStatsWidget extends StatefulWidget {
  const QuickStatsWidget({super.key});

  @override
  State<QuickStatsWidget> createState() => _QuickStatsWidgetState();
}

class _QuickStatsWidgetState extends State<QuickStatsWidget> {
  @override
  void initState() {
    super.initState();
    // Load data when widget initializes
    context.read<SessionsCubit>().loadSessions();
    context.read<TeacherStudentsCubit>().loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Text(
            'إحصائيات سريعة',
            style: AppTextStyle.textStyle18Bold.copyWith(
              color: AppColors.primaryBlueViolet,
            ),
          ),

          SizedBox(height: 16.h),

          // إحصائيات الطلاب والجلسات
          Row(
            children: [
              // إجمالي الطلاب
              Expanded(
                child: BlocBuilder<TeacherStudentsCubit, TeacherStudentsState>(
                  builder: (context, state) {
                    int totalStudents = 0;
                    bool isLoading = false;

                    if (state is TeacherStudentsLoading) {
                      isLoading = true;
                    } else if (state is TeacherStudentsLoaded) {
                      totalStudents = state.students.length;
                    }

                    return _buildStatCard(
                      title: 'إجمالي الطلاب',
                      value: isLoading ? '...' : totalStudents.toString(),
                      color: AppColors.primaryBlueViolet,
                      icon: Icons.school_rounded,
                      isLoading: isLoading,
                    );
                  },
                ),
              ),

              SizedBox(width: 12.w),

              // إجمالي الجلسات
              Expanded(
                child: BlocBuilder<SessionsCubit, SessionsState>(
                  builder: (context, state) {
                    int totalSessions = 0;
                    bool isLoading = false;

                    if (state is SessionsLoading) {
                      isLoading = true;
                    } else if (state is SessionsLoaded) {
                      totalSessions = state.sessions.length;
                    }

                    return _buildStatCard(
                      title: 'إجمالي الجلسات',
                      value: isLoading ? '...' : totalSessions.toString(),
                      color: AppColors.primarySuccess,
                      icon: Icons.video_call_rounded,
                      isLoading: isLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              const Spacer(),
              const Spacer(),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: color.withOpacity(0.4),
                      highlightColor: color.withOpacity(0.1),
                      child: Container(
                        width: 30.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: AppTextStyle.textStyle24Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyle.textStyle14Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
