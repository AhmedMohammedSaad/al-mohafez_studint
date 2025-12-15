import 'dart:io';

import 'package:almohafez/almohafez_teacher/features/profile/data/models/local_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = AppConst.userProfile;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      if (user.profileImagePath != null && user.profileImagePath!.isNotEmpty) {
        _profileImageFile = File(user.profileImagePath!);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImageFile = File(picked.path));
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    final updated = LocalUserModel(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      profileImagePath: _profileImageFile?.path,
    );
    AppConst.userProfile = updated;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('success'.tr())));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_profile'.tr())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundColor: AppColors.greenColor.withOpacity(0.1),
                  backgroundImage: _profileImageFile != null
                      ? FileImage(_profileImageFile!)
                      : const AssetImage('assets/images/placeholder.webp')
                            as ImageProvider,
                ),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'first_name'.tr()),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'last_name'.tr()),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'email'.tr()),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'phone_number'.tr()),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('save'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
