import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';

import 'package:almohafez/almohafez_teacher/features/authentication/presentation/views/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import 'package:almohafez/almohafez_teacher/features/authentication/data/teacher_auth_service.dart';
import 'package:almohafez/almohafez_teacher/features/profile/data/models/teacher_profile_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _qualificationsController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  String _selectedGender = 'male';

  // Availability schedule
  final List<AvailabilitySlot> _availabilitySlots = [];

  // Helper to format time to 12-hour format with AM/PM (localized)
  String _formatTime(int totalMinutes) {
    if (!mounted) return '';
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      totalMinutes ~/ 60,
      totalMinutes % 60,
    );
    return DateFormat('h:mm a', context.locale.toString()).format(dt);
  }

  List<Map<String, String>> _generateDailySlots() {
    List<Map<String, String>> slots = [];
    int currentMinutes = 4 * 60; // Start at 04:00 AM
    const int sessionDuration = 60;
    const int endOfDay = 24 * 60; // End at midnight

    while (currentMinutes + sessionDuration <= endOfDay) {
      int endMinutes = currentMinutes + sessionDuration;

      final startHour = (currentMinutes ~/ 60).toString().padLeft(2, '0');
      final startMinute = (currentMinutes % 60).toString().padLeft(2, '0');
      final endHour = (endMinutes ~/ 60).toString().padLeft(2, '0');
      final endMinute = (endMinutes % 60).toString().padLeft(2, '0');

      // Localized display
      final displayStart = _formatTime(currentMinutes);
      final displayEnd = _formatTime(endMinutes);

      slots.add({
        'start': '$startHour:$startMinute',
        'end': '$endHour:$endMinute',
        'display': '$displayStart - $displayEnd',
      });

      currentMinutes = endMinutes;
    }
    return slots;
  }

  Future<void> _addAvailabilitySlot() async {
    String? selectedDay;
    List<Map<String, String>> selectedTimeSlots = [];
    final List<Map<String, String>> allDailySlots = _generateDailySlots();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: Text('add_availability'.tr()),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instructions Card
                      Container(
                        padding: EdgeInsets.all(12.w),
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueViolet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryBlueViolet.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.primaryBlueViolet,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'availability_instructions_title'.tr(),
                                  style: AppTextStyle.medium14.copyWith(
                                    color: AppColors.primaryBlueViolet,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'availability_instructions_body'.tr(),
                              style: AppTextStyle.regular12.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedDay,
                        isExpanded: true,
                        hint: Text('select_day'.tr()),
                        items:
                            [
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday',
                                  'Saturday',
                                  'Sunday',
                                ]
                                .map(
                                  (day) => DropdownMenuItem(
                                    value: day,
                                    child: Text(
                                      'days_${day.toLowerCase()}'.tr(),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => selectedDay = v),
                      ),
                      SizedBox(height: 16.h),
                      if (selectedDay != null) ...[
                        Text('select_time_slots'.tr()),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: allDailySlots.map((slot) {
                            final isSelected = selectedTimeSlots.any(
                              (s) =>
                                  s['start'] == slot['start'] &&
                                  s['end'] == slot['end'],
                            );
                            return ChoiceChip(
                              label: Text(slot['display']!),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedTimeSlots.add(slot);
                                  } else {
                                    selectedTimeSlots.removeWhere(
                                      (s) =>
                                          s['start'] == slot['start'] &&
                                          s['end'] == slot['end'],
                                    );
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr()),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedDay != null && selectedTimeSlots.isNotEmpty) {
                      final newSlots = selectedTimeSlots.map((slot) {
                        return AvailabilitySlot(
                          day: selectedDay!,
                          start: slot['start']!,
                          end: slot['end']!,
                        );
                      }).toList();

                      Navigator.pop(context, newSlots);
                    }
                  },
                  child: Text('add'.tr()),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is List<AvailabilitySlot>) {
        setState(() {
          _availabilitySlots.addAll(result);
        });
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _qualificationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                AppCustomImageView(
                  imagePath: 'assets/images/logo_almohafz.png',
                  width: 180.w,
                  height: 100.h,
                ),
                // Header
                AuthHeader(
                  title: 'create_account'.tr(),
                  subtitle: 'join_us_today'.tr(),
                ),

                // First Name Field
                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(
                        labelText: 'first_name'.tr(),
                        hintText: 'enter_first_name'.tr(),
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        isRequired: true,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                          size: 20.sp,
                        ),
                        validator: _validateFirstName,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AuthTextField(
                        labelText: 'last_name'.tr(),
                        hintText: 'enter_last_name'.tr(),
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        isRequired: true,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                          size: 20.sp,
                        ),
                        validator: _validateLastName,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Email Field
                AuthTextField(
                  labelText: 'email'.tr(),
                  hintText: 'enter_your_email'.tr(),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  validator: _validateEmail,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 20.h),

                // Phone Field
                AuthTextField(
                  labelText: 'رقم التليفون',
                  hintText: 'أدخل رقم التليفون',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  validator: _validatePhone,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 20.h),

                // Gender Selection
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'gender'.tr(),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primaryBlueViolet,
                      ),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'male',
                      child: Text('gender_male'.tr()),
                    ),
                    DropdownMenuItem(
                      value: 'female',
                      child: Text('gender_female'.tr()),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),

                SizedBox(height: 20.h),

                // Password Field
                AuthTextField(
                  labelText: 'password'.tr(),
                  hintText: 'create_password'.tr(),
                  controller: _passwordController,
                  isPassword: true,
                  isRequired: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  validator: _validatePassword,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 20.h),

                // Confirm Password Field
                AuthTextField(
                  labelText: 'confirm_password'.tr(),
                  hintText: 'confirm_your_password'.tr(),
                  controller: _confirmPasswordController,
                  isPassword: true,
                  isRequired: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  validator: _validateConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSignUp(),
                ),

                SizedBox(height: 20.h),

                // Profile Image Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الصورة الشخصية',
                        style: AppTextStyle.medium16.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          // Image Preview
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundPrimary,
                              borderRadius: BorderRadius.circular(40.r),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: _profileImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40.r),
                                    child: Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person_outline,
                                    size: 40.sp,
                                    color: AppColors.textSecondary,
                                  ),
                          ),
                          SizedBox(width: 16.w),
                          // Upload Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                size: 20.sp,
                                color: AppColors.primaryBlueViolet,
                              ),
                              label: Text(
                                'اختيار صورة',
                                style: AppTextStyle.medium14.copyWith(
                                  color: AppColors.primaryBlueViolet,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundPrimary,
                                side: BorderSide(
                                  color: AppColors.primaryBlueViolet,
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Qualifications Field
                AuthTextField(
                  labelText: 'المؤهلات',
                  hintText: 'أدخل مؤهلاتك العلمية والخبرات',
                  controller: _qualificationsController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  isRequired: true,
                  prefixIcon: Icon(
                    Icons.school_outlined,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  validator: _validateQualifications,
                  textInputAction: TextInputAction.newline,
                ),

                SizedBox(height: 20.h),

                // Availability Schedule Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الأوقات المتاحة',
                        style: AppTextStyle.medium16.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'حدد الأوقات المتاحة لكل يوم من أيام الأسبوع',
                        style: AppTextStyle.regular14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // List of added slots
                      ..._availabilitySlots.map(
                        (slot) => Card(
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            title: Text('days_${slot.day.toLowerCase()}'.tr()),
                            subtitle: Text('${slot.start} - ${slot.end}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _availabilitySlots.remove(slot);
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      ElevatedButton.icon(
                        onPressed: _addAvailabilitySlot,
                        icon: Icon(Icons.add, color: Colors.white, size: 20.sp),
                        label: Text(
                          'add_slot'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlueViolet,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Terms and Conditions Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryBlueViolet,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyle.medium14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: 'i_agree_to'.tr()),
                            TextSpan(
                              text: ' ${'terms_of_service'.tr()}',
                              style: AppTextStyle.medium14.copyWith(
                                color: AppColors.primaryBlueViolet,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' ${'and'.tr()} '),
                            TextSpan(
                              text: 'privacy_policy'.tr(),
                              style: AppTextStyle.medium14.copyWith(
                                color: AppColors.primaryBlueViolet,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Sign Up Button
                AuthButton(
                  text: 'create_account'.tr(),
                  onPressed: _acceptTerms ? _handleSignUp : null,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 24.h),

                // Divider
                // Row(
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         color: AppColors.borderLight,
                //         thickness: 1,
                //       ),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 16.w),
                //       child: Text(
                //         'or_sign_up_with'.tr(),
                //         style: AppTextStyle.medium14.copyWith(
                //           color: AppColors.textSecondary,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Divider(
                //         color: AppColors.borderLight,
                //         thickness: 1,
                //       ),
                //     ),
                //   ],
                // ),

                // SizedBox(height: 24.h),

                // // Social Login Buttons
                // SocialLoginButton(
                //   type: SocialLoginType.google,
                //   onPressed: _handleGoogleSignUp,
                //   customText: 'sign_up_with_google'.tr(),
                // ),

                // SizedBox(height: 32.h),

                // // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already_have_account'.tr(),
                      style: AppTextStyle.medium14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'sign_in'.tr(),
                        style: AppTextStyle.medium14.copyWith(
                          color: AppColors.primaryBlueViolet,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'first_name_required'.tr();
    }
    if (value.length < 2) {
      return 'first_name_too_short'.tr();
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'last_name_required'.tr();
    }
    if (value.length < 2) {
      return 'last_name_too_short'.tr();
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr();
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'invalid_email'.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr();
    }
    if (value.length < 8) {
      return 'password_min_length'.tr();
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr();
    }
    if (value != _passwordController.text) {
      return 'passwords_dont_match'.tr();
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم التليفون مطلوب';
    }
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
      return 'رقم التليفون غير صحيح';
    }
    if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
      return 'رقم التليفون يجب أن يكون 10 أرقام على الأقل';
    }
    return null;
  }

  String? _validateQualifications(String? value) {
    if (value == null || value.isEmpty) {
      return 'المؤهلات مطلوبة';
    }
    if (value.length < 10) {
      return 'يرجى إدخال تفاصيل أكثر عن مؤهلاتك';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'فشل في اختيار الصورة',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryError,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      Fluttertoast.showToast(
        msg: 'accept_terms_required'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryError,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Validate profile image
    if (_profileImage == null) {
      Fluttertoast.showToast(
        msg: 'يرجى اختيار صورة شخصية',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryError,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Validate availability schedule (at least one day should be selected)
    if (_availabilitySlots.isEmpty) {
      Fluttertoast.showToast(
        msg: 'يرجى تحديد الأوقات المتاحة ليوم واحد على الأقل',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryError,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = TeacherAuthService();

      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender,
        qualifications: _qualificationsController.text.trim(),
        availabilitySlots: _availabilitySlots
            .map((e) => {'day': e.day, 'start': e.start, 'end': e.end})
            .toList(), // Pass properly formatted slots
        profileImage: _profileImage,
      );

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'تم إنشاء الحساب بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: '${'sign_up_failed'.tr()}: ${e.toString()}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryError,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
