import 'package:almohafez/almohafez_teacher/features/profile/presentation/cubit/teacher_profile_cubit.dart';
import 'package:almohafez/almohafez_teacher/features/profile/presentation/cubit/teacher_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'action_button_widget.dart';
import '../../data/models/teacher_profile_model.dart';
import '../views/edit_profile_screen.dart';
import '../views/change_password_screen.dart';
import '../views/contact_us_screen.dart';
import '../../../authentication/presentation/views/login_screen.dart';

class ActionButtonsWidget extends StatelessWidget {
  final TeacherProfileModel? profile;

  const ActionButtonsWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherProfileCubit, TeacherProfileState>(
      listener: (context, state) {
        if (state is TeacherProfileLoggedOut) {
          // Navigate to Login Screen and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Column(
        children: [
          ActionButtonWidget(
            title: 'profile_edit_data'.tr(),
            icon: Icons.edit,
            color: const Color(0xFF3B82F6),
            onPressed: () => _handleEditProfile(context),
          ),
          SizedBox(height: 12.h),
          ActionButtonWidget(
            title: 'profile_change_password'.tr(),
            icon: Icons.lock,
            color: const Color(0xFF10B981),
            onPressed: () => _handleChangePassword(context),
          ),
          SizedBox(height: 12.h),
          ActionButtonWidget(
            title: 'profile_contact_us'.tr(),
            icon: Icons.support_agent,
            color: const Color(0xFFF59E0B),
            onPressed: () => _handleContactUs(context),
          ),
          SizedBox(height: 12.h),
          ActionButtonWidget(
            title: 'profile_delete_account'.tr(),
            icon: Icons.delete_forever,
            color: const Color(0xFFEF4444),
            onPressed: () => _handleDeleteAccount(context),
          ),
          SizedBox(height: 12.h),
          ActionButtonWidget(
            title: 'profile_logout'.tr(),
            icon: Icons.logout,
            color: const Color(0xFF6B7280),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  void _handleEditProfile(BuildContext context) {
    if (profile == null) {
      Fluttertoast.showToast(
        msg: 'Wait for profile to load',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile!),
      ),
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

        context.read<TeacherProfileCubit>().deleteAccount();
      },
    );
  }

  void _handleLogout(BuildContext context) {
    _showConfirmationDialog(
      context,
      'profile_logout_title'.tr(),
      'profile_logout_message'.tr(),
      'profile_logout_confirm'.tr(),
      const Color(0xFF6B7280),
      () async {
        Navigator.of(context).pop();

        context.read<TeacherProfileCubit>().logout();
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
