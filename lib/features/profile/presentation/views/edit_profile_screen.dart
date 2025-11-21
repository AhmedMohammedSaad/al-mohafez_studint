import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/profile_bloc.dart';
import '../../logic/profile_event.dart';
import '../../logic/profile_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentFirstName;
  final String currentLastName;

  const EditProfileScreen({
    super.key,
    required this.currentFirstName,
    required this.currentLastName,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.currentFirstName);
    _lastNameController = TextEditingController(text: widget.currentLastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'edit_profile_title'.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A1D64),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0A1D64)),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            setState(() => _isLoading = true);
          } else if (state is ProfileLoaded) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('profile_updated_successfully'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primaryError,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24.h),

                // First Name Field
                Text(
                  'first_name'.tr(),
                  style: AppTextStyle.medium16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0A1D64),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: 'enter_first_name'.tr(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: Color(0xFF0A1D64),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'first_name_required'.tr();
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24.h),

                // Last Name Field
                Text(
                  'last_name'.tr(),
                  style: AppTextStyle.medium16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0A1D64),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: 'enter_last_name'.tr(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: Color(0xFF0A1D64),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'last_name_required'.tr();
                    }
                    return null;
                  },
                ),

                SizedBox(height: 40.h),

                // Save Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A1D64),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'save_changes'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        ),
      );
    }
  }
}
