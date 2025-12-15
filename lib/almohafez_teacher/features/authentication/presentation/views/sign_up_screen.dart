import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/almohafez/core/routing/app_route.dart';
import 'package:almohafez/almohafez_teacher/features/profile/data/models/local_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:nb_utils/nb_utils.dart' as NavigationService;
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/social_login_button.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';
import 'package:almohafez/almohafez/core/data/local_data/caching_helper.dart';

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

  // Availability schedule
  Map<String, Map<String, TimeOfDay?>> _availability = {
    'saturday': {'start': null, 'end': null},
    'sunday': {'start': null, 'end': null},
    'monday': {'start': null, 'end': null},
    'tuesday': {'start': null, 'end': null},
    'wednesday': {'start': null, 'end': null},
    'thursday': {'start': null, 'end': null},
    'friday': {'start': null, 'end': null},
  };

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
                      ..._buildAvailabilitySchedule(),
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
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'password_requirements'.tr();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في اختيار الصورة'),
          backgroundColor: AppColors.primaryError,
        ),
      );
    }
  }

  List<Widget> _buildAvailabilitySchedule() {
    final days = [
      {'key': 'saturday', 'name': 'السبت'},
      {'key': 'sunday', 'name': 'الأحد'},
      {'key': 'monday', 'name': 'الاثنين'},
      {'key': 'tuesday', 'name': 'الثلاثاء'},
      {'key': 'wednesday', 'name': 'الأربعاء'},
      {'key': 'thursday', 'name': 'الخميس'},
      {'key': 'friday', 'name': 'الجمعة'},
    ];

    return days.map((day) {
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day['name']!,
              style: AppTextStyle.medium14.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(child: _buildTimeSelector(day['key']!, 'start', 'من')),
                SizedBox(width: 12.w),
                Expanded(child: _buildTimeSelector(day['key']!, 'end', 'إلى')),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTimeSelector(String day, String type, String label) {
    final time = _availability[day]![type];
    return GestureDetector(
      onTap: () => _selectTime(day, type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.backgroundPrimary,
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                time != null
                    ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                    : label,
                style: AppTextStyle.regular14.copyWith(
                  color: time != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(String day, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _availability[day]![type] ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlueViolet,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _availability[day]![type] = picked;
      });
    }
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('accept_terms_required'.tr()),
          backgroundColor: AppColors.primaryError,
        ),
      );
      return;
    }

    // Validate profile image
    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى اختيار صورة شخصية'),
          backgroundColor: AppColors.primaryError,
        ),
      );
      return;
    }

    // Validate availability schedule (at least one day should be selected)
    bool hasAvailability = false;
    for (var day in _availability.values) {
      if (day['start'] != null && day['end'] != null) {
        hasAvailability = true;
        break;
      }
    }

    if (!hasAvailability) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى تحديد الأوقات المتاحة ليوم واحد على الأقل'),
          backgroundColor: AppColors.primaryError,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual sign up API logic
      // Prepare local user data for caching
      final localUser = LocalUserModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        profileImagePath: _profileImage?.path,
      );

      // Cache local user and dummy tokens (until API integration)
      AppConst.userProfile = localUser;
      await AppCacheHelper.cacheSecureString(
        key: AppCacheHelper.accessTokenKey,
        value: 'dummy_access_${DateTime.now().millisecondsSinceEpoch}',
      );
      await AppCacheHelper.cacheSecureString(
        key: AppCacheHelper.refreshTokenKey,
        value: 'dummy_refresh_${DateTime.now().millisecondsSinceEpoch}',
      );
      await AppCacheHelper.markProfileCompleted();

      // For debugging
      print('User registration data cached: ${localUser.toJson()}');

      await Future.delayed(const Duration(seconds: 2));

      // Navigate to verification screen or main app
      if (mounted) {
        NavigationService.push(AppRouter.kMainScreen as Widget);
      }
    } catch (e) {
      // TODO: Handle sign up error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('sign_up_failed'.tr()),
            backgroundColor: AppColors.primaryError,
          ),
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
    NavigationService.push(AppRouter.kLoginScreen as Widget);
  }
}
