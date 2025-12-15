import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'action_button_widget.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  void _handleEditProfile(BuildContext context) {
    // TODO: Navigate to edit profile screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('profile_edit_data_message'.tr())));
  }

  void _handleChangePassword(BuildContext context) {
    // TODO: Navigate to change password screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('profile_change_password_message'.tr())),
    );
  }

  void _handleContactUs(BuildContext context) {
    // TODO: Navigate to contact us screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('profile_contact_us_message'.tr())));
  }

  void _handleDeleteAccount(BuildContext context) {
    _showConfirmationDialog(
      context,
      'profile_delete_account_title'.tr(),
      'profile_delete_account_message'.tr(),
      'profile_delete_account_confirm'.tr(),
      const Color(0xFFEF4444),
      () {
        // TODO: Implement account deletion
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('profile_delete_account_success'.tr())),
        );
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
      () {
        // TODO: Implement logout
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('profile_logout_success'.tr())));
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
