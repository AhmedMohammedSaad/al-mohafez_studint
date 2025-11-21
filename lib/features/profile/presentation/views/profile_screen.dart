import 'package:almohafez/features/profile/data/repos/profile_repo.dart';
import 'package:almohafez/features/profile/logic/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/statistics_cards_widget.dart';
import '../widgets/action_buttons_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/profile_bloc.dart';

import '../../logic/profile_state.dart';

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
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go(AppRouter.kLoginScreen);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ProfileHeaderWidget(
                      fullName: profile.fullName,
                      email: profile.email,
                      avatarUrl: profile.avatarUrl,
                    ),
                    SizedBox(height: 24.h),
                    const StatisticsCardsWidget(),
                    SizedBox(height: 24.h),
                    const ActionButtonsWidget(),
                    SizedBox(height: 65.h),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
