import 'package:almohafez/almohafez_teacher/features/profile/presentation/cubit/teacher_profile_cubit.dart';
import 'package:almohafez/almohafez_teacher/features/profile/presentation/cubit/teacher_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/error_widget.dart';

import '../widgets/profile_header_widget.dart';
import '../widgets/statistics_cards_widget.dart';
import '../widgets/action_buttons_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'profile_title'.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A1D64),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
        builder: (context, state) {
          if (state is TeacherProfileLoading) {
            return _buildLoadingState();
          } else if (state is TeacherProfileError) {
            return AppErrorWidget(
              message: state.message,
              onRefresh: () {
                context.read<TeacherProfileCubit>().loadProfile();
              },
            );
          } else if (state is TeacherProfileLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  ProfileHeaderWidget(profile: state.profile),
                  SizedBox(height: 24.h),
                  StatisticsCardsWidget(profile: state.profile),
                  SizedBox(height: 10.h),
                  ActionButtonsWidget(profile: state.profile),
                  SizedBox(height: 65.h),
                ],
              ),
            );
          }
          // Handle initial state or generic case by showing empty or loading
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            // Profile Header Loading
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(height: 24.h),

            // Stats Cards Loading
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    height: 100.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // Action Buttons Loading
            Column(
              children: List.generate(
                4,
                (index) => Container(
                  height: 60.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 65.h),
          ],
        ),
      ),
    );
  }
}
