import 'package:almohafez/almohafez/features/profile/logic/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'edit_profile_screen.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/statistics_cards_widget.dart';
import '../widgets/action_buttons_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/profile_bloc.dart';

import '../../logic/profile_state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/view/widgets/error_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(LoadProfileEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const SizedBox(), // Hide back button if it's a main tab
          title: Text(
            'profile_title'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go(AppRouter.kLoginScreen);
          } else if (state is ProfileError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return _buildShimmerLoading();
            } else if (state is ProfileError) {
              return AppErrorWidget(
                message: state.message,
                onRefresh: () {
                  context.read<ProfileBloc>().add(LoadProfileEvent());
                },
              );
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(LoadProfileEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
                color: const Color(0xFF0A1D64),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: kToolbarHeight + 20.h),
                      // Header Section with Glassmorphism effect or simple clean card
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ProfileHeaderWidget(
                          fullName: profile.fullName,
                          email: profile.email,
                          avatarUrl: profile.avatarUrl,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  currentFirstName: profile.firstName,
                                  currentLastName: profile.lastName,
                                  currentPhoneNumber: profile.phoneNumber,
                                ),
                              ),
                            );
                          },
                        ),
                      ).animate().fade().scale(
                        duration: 400.ms,
                        curve: Curves.easeOutBack,
                      ),

                      SizedBox(height: 24.h),

                      // Statistics Section
                      StatisticsCardsWidget(
                            sessionsCount: profile.totalSessions,
                            totalRate: profile.averageScore,
                          )
                          .animate()
                          .fade(delay: 200.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),

                      SizedBox(height: 24.h),

                      // Actions Section
                      const ActionButtonsWidget()
                          .animate()
                          .fade(delay: 400.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight + 20.h),
            // Header Shimmer
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            SizedBox(height: 24.h),
            // Statistics Shimmer
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Actions Shimmer
            Container(
              height: 300.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
