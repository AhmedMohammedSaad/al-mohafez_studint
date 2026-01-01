import '../../data/models/teacher_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:almohafez/almohafez_teacher/features/students/presentation/cubit/teacher_students_cubit.dart';
import 'package:almohafez/almohafez_teacher/features/students/presentation/cubit/teacher_students_state.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/cubit/sessions_cubit.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/cubit/sessions_state.dart';

class StatisticsCardsWidget extends StatefulWidget {
  final TeacherProfileModel? profile;

  const StatisticsCardsWidget({super.key, this.profile});

  @override
  State<StatisticsCardsWidget> createState() => _StatisticsCardsWidgetState();
}

class _StatisticsCardsWidgetState extends State<StatisticsCardsWidget> {
  @override
  void initState() {
    super.initState();
    // Load data when widget initializes
    context.read<TeacherStudentsCubit>().loadStudents();
    context.read<SessionsCubit>().loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // عدد الطلاب
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

              return _buildStatisticCard(
                context,
                icon: Icons.school,
                title: 'students'.tr(),
                value: isLoading ? '...' : totalStudents.toString(),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                isLoading: isLoading,
              );
            },
          ),
        ),

        SizedBox(width: 16.w),

        // عدد الجلسات
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

              return _buildStatisticCard(
                context,
                icon: Icons.class_,
                title: 'sessions'.tr(),
                value: isLoading ? '...' : totalSessions.toString(),
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                isLoading: isLoading,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Gradient gradient,
    bool isLoading = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.sp, color: Colors.white),
          SizedBox(height: 16.h),
          isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.white.withOpacity(0.5),
                  child: Container(
                    width: 40.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
