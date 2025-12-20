import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';
import '../../data/models/teacher_profile_model.dart';
import '../cubit/teacher_profile_cubit.dart';
import '../cubit/teacher_profile_state.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';

class EditProfileScreen extends StatefulWidget {
  final TeacherProfileModel profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
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

    // If image changed, upload it first (or concurrently, but simple here)
    if (_profileImageFile != null) {
      context.read<TeacherProfileCubit>().uploadProfileImage(
        _profileImageFile!,
      );
    }

    final updatedProfile = widget.profile.copyWith(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      bio: _bioController.text.trim(),
    );

    context.read<TeacherProfileCubit>().updateProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_profile'.tr())),
      body: BlocListener<TeacherProfileCubit, TeacherProfileState>(
        listener: (context, state) {
          if (state is TeacherProfileUpdateSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          } else if (state is TeacherProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryBlueViolet,
                        width: 2,
                      ),
                    ),
                    child: _profileImageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImageFile!,
                              width: 90.w,
                              height: 90.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: AppCustomImageView(
                              imagePath: widget.profile.profilePictureUrl,
                              width: 90.w,
                              height: 90.w,
                              fit: BoxFit.cover,
                              placeHolder: 'assets/images/placeholder.webp',
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'full_name'.tr(),
                  ), // Changed key to generic full name
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
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(labelText: 'Bio'),
                  maxLines: 3,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is TeacherProfileUpdating
                            ? null
                            : _saveProfile,
                        child: state is TeacherProfileUpdating
                            ? const CircularProgressIndicator()
                            : Text('save'.tr()),
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
