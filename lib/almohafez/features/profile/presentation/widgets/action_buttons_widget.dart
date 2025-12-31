import 'package:almohafez/almohafez/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:almohafez/almohafez/features/profile/presentation/views/contact_us_screen.dart';
import 'package:almohafez/almohafez_teacher/features/authentication/presentation/views/login_screen.dart';
import 'package:almohafez/almohafez_teacher/features/profile/presentation/views/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/profile_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';
import 'language_selection_dialog.dart';

import 'action_button_widget.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle('profile_general'.tr()),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              ActionButtonWidget(
                title: 'profile_edit_data'.tr(),
                icon: Icons.person_outline,
                color: const Color(0xFF0A1D64),
                onPressed: () => _handleEditProfile(context),
              ),
              _buildDivider(),
              ActionButtonWidget(
                title: 'profile_change_language'.tr(),
                icon: Icons.language,
                color: const Color(0xFF0A1D64),
                onPressed: () => _handleChangeLanguage(context),
              ),
              _buildDivider(),
              ActionButtonWidget(
                title: 'profile_change_password'.tr(),
                icon: Icons.lock_outline,
                color: const Color(0xFF0A1D64),
                showDivider: false,
                onPressed: () => _handleChangePassword(context),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        _buildSectionTitle('profile_support'.tr()),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              ActionButtonWidget(
                title: 'profile_contact_us'.tr(),
                icon: Icons.headset_mic_outlined,
                color: const Color(0xFF0A1D64),
                onPressed: () => _handleContactUs(context),
              ),
              _buildDivider(),
              ActionButtonWidget(
                title: 'profile_delete_account'.tr(),
                icon: Icons.delete_outline,
                color: const Color(0xFFEF4444),
                onPressed: () => _handleDeleteAccount(context),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ActionButtonWidget(
                title: 'profile_logout'.tr(),
                icon: Icons.logout,
                color: const Color(0xFF0A1D64),
                showDivider: false,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          title: Text(
                            'profile_logout_title'.tr(),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0A1D64),
                            ),
                          ),
                          content: Text(
                            'profile_logout_message'.tr(),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'profile_cancel'.tr(),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();

                                context.read<ProfileBloc>().add(LogoutEvent());

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'profile_logout_confirm'.tr(),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0A1D64),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF3F4F6),
      indent: 16.w,
      endIndent: 16.w,
    );
  }

  void _handleEditProfile(BuildContext context) {
    // Get current profile data from BLoC
    final profileBloc = context.read<ProfileBloc>();
    final state = profileBloc.state;

    if (state is ProfileLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            currentFirstName: state.profile.firstName,
            currentLastName: state.profile.lastName,
            currentPhoneNumber: state.profile.phoneNumber,
          ),
        ),
      );
    }
  }

  void _handleChangeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageSelectionDialog(),
    );
  }

  void _handleChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  void _handleContactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactUsScreen()),
    );
  }

  void _handleDeleteAccount(BuildContext context) {
    _showConfirmationDialog(
      context,
      'profile_delete_account_title'.tr(),
      'profile_delete_account_message'.tr(),
      'profile_delete_account_confirm'.tr(),
      const Color(0xFFEF4444),
      () {
        Navigator.of(context).pop();
        context.read<ProfileBloc>().add(DeleteAccountEvent());
      },
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    String confirmText,
    Color confirmColor,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'profile_cancel'.tr(),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                confirmText,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
