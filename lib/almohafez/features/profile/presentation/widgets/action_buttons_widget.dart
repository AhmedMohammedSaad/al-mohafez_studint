import 'package:almohafez/almohafez/features/authentication/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../logic/profile_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';
import '../../../../core/routing/app_route.dart';
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
                      'profile_delete_account_message'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0A1D64),
                      ),
                    ),
                    content: Text(
                      'profile_delete_account_confirm'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: const Color.fromARGB(255, 198, 4, 4),
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<ProfileBloc>().add(DeleteAccountEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "Confirm",
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
        SizedBox(height: 12.h),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return ActionButtonWidget(
              title: 'profile_logout'.tr(),
              icon: Icons.logout,
              color: const Color(0xFF6B7280),
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
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<ProfileBloc>().add(LogoutEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B7280),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Confirm",
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
              // onPressed: () => _showConfirmationDialog(
              // context,
              // 'profile_logout_title'.tr(),
              // 'profile_logout_message'.tr(),
              // 'profile_logout_confirm'.tr(),
              // const Color(0xFF6B7280),
              // () {
              // context.read<ProfileBloc>().add(LogoutEvent());
              // if (state is ProfileLoaded) {
              // Navigator.pop(context);
              // }
              // Navigator.of(context).pop();
              // },
              // ),
            );
          },
        ),
      ],
    );
  }

  void _handleEditProfile(BuildContext context) {
    // Get current profile data from BLoC
    final profileBloc = context.read<ProfileBloc>();
    final state = profileBloc.state;

    if (state is ProfileLoaded) {
      context.push(
        AppRouter.kEditProfileScreen,
        extra: {
          'firstName': state.profile.firstName,
          'lastName': state.profile.lastName,
        },
      );
    }
  }

  void _handleChangePassword(BuildContext context) {
    context.push(AppRouter.kChangePasswordScreen);
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
        Navigator.of(context).pop();
        context.read<ProfileBloc>().add(DeleteAccountEvent());
      },
    );
  }
  //
  // void _handleLogout(BuildContext context) {
  // _showConfirmationDialog(
  // context,
  // 'profile_logout_title'.tr(),
  // 'profile_logout_message'.tr(),
  // 'profile_logout_confirm'.tr(),
  // const Color(0xFF6B7280),
  // () {
  // context.read<ProfileBloc>().add(LogoutEvent());
  // Navigator.of(context).pop();
  // },
  // );
  // }

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
