import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/almohafez/core/routing/app_route.dart';
import 'package:almohafez/almohafez/features/authentication/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../../../core/services/navigation_service/global_navigation_service.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/social_login_button.dart';
import '../../data/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/supabase_error_handler.dart';

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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'sign_up_success'.tr(),
            ), // Make sure to add this key to translations or use a hardcoded string for now
            backgroundColor: Colors.green,
          ),
        );
        NavigationService.goTo(AppRouter.kMainScreen);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SupabaseErrorHandler.getErrorMessage(e)),
            backgroundColor: AppColors.primaryError,
          ),
        );
      }
    } catch (e) {
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
