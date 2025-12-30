import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../cubit/teacher_profile_cubit.dart';
import '../cubit/teacher_profile_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TeacherProfileCubit>().changePassword(
      _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_password'.tr())),
      body: BlocListener<TeacherProfileCubit, TeacherProfileState>(
        listener: (context, state) {
          if (state is TeacherProfileUpdateSuccess) {
            Fluttertoast.showToast(
              msg: 'password_changed_success'.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context);
          } else if (state is TeacherProfileError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.primaryError,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Note: Current password verification typically requires re-authentication or a specific endpoint.
                // Supabase updateUser doesn't strictly verify old password unless configured, but for UI flow we might ask for it.
                // Since this is a simple implementation, we might skip verify old password on client side other than field existence,
                // assuming the user is already authenticated.
                // However, strictly speaking, change password usually needs old password for security re-verification.
                // Given the cubit just calls updateUser(password: new), we'll proceed.
                // If better security is needed, we would re-sign in with old password first.
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: 'new_password'.tr()),
                  obscureText: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'field_required'.tr()
                      : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  decoration: InputDecoration(
                    labelText: 'confirm_new_password'.tr(),
                  ),
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'field_required'.tr();
                    }
                    if (v != _newPasswordController.text) {
                      return 'passwords_do_not_match'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is TeacherProfileUpdating
                            ? null
                            : _changePassword,
                        child: state is TeacherProfileUpdating
                            ? const CircularProgressIndicator()
                            : Text('change_password'.tr()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
