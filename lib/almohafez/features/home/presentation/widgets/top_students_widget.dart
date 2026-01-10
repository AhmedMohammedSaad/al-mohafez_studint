import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/repositories/top_students_repo.dart';
import '../cubit/top_students_cubit.dart';
import '../cubit/top_students_state.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TopStudentsWidget extends StatelessWidget {
  const TopStudentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TopStudentsCubit(TopStudentsRepo(Supabase.instance.client))
            ..loadTopStudents(),
      child: const _TopStudentsContent(),
    );
  }
}

class _TopStudentsContent extends StatelessWidget {
  const _TopStudentsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'top_students_title'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A1D64),
          ),
        ),
        SizedBox(height: 15.h),
        BlocBuilder<TopStudentsCubit, TopStudentsState>(
          builder: (context, state) {
            if (state is TopStudentsLoading) {
              return _buildLoadingList();
            }

            if (state is TopStudentsError) {
              return SizedBox(
                height: 150.h,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: const Color(0xFFFF4C5E),
                          size: 32.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        TextButton.icon(
                          onPressed: () {
                            context.read<TopStudentsCubit>().loadTopStudents();
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text('retry'.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is TopStudentsLoaded) {
              if (state.students.isEmpty) {
                return SizedBox(
                  height: 120.h,
                  child: Center(
                    child: Text(
                      'no_top_students'.tr(),
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 120.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.students.length,
                  itemBuilder: (context, index) {
                    final student = state.students[index];
                    final rank = index + 1;
                    return _StudentCard(
                          name: student.name,
                          progress: student.progress,
                          rank: rank,
                        )
                        .animate()
                        .fade(duration: 400.ms, delay: (100 * index).ms)
                        .slideX(begin: 0.2, end: 0, curve: Curves.easeOut);
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 90.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
                  SizedBox(height: 7.h),
                  // Circle placeholder
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Text placeholder
                  Container(
                    width: 60.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name;
  final double progress;
  final int rank;

  const _StudentCard({
    required this.name,
    required this.progress,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          SizedBox(height: 7.h),
          Stack(
            alignment: Alignment.center,
            children: [
              // دائرة التقدم
              SizedBox(
                width: 70.w,
                height: 70.h,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: const Color(
                    0xFF00E0FF,
                  ).withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF00E0FF),
                  ),
                ),
              ),

              // صورة الطالب
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0A1D64).withValues(alpha: 0.1),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  size: 30.sp,
                  color: const Color(0xFF0A1D64),
                ),
              ),

              // رقم الترتيب
              if (rank <= 3)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rank == 1
                          ? const Color(0xFFFFD700)
                          : rank == 2
                          ? const Color(0xFFC0C0C0)
                          : const Color(0xFFCD7F32),
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
