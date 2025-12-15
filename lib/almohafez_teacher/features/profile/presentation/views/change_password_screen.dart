import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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
    // TODO: Implement password change logic
    // 1. Verify the current password
    // 2. Update the password
    // 3. Show a success message
    // 4. Navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('password_changed_success'.tr())),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change_password'.tr()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(labelText: 'current_password'.tr()),
                obscureText: true,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: 16.h),
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
                decoration: InputDecoration(labelText: 'confirm_new_password'.tr()),
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
                child: ElevatedButton(
                  onPressed: _changePassword,
                  child: Text('change_password'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}