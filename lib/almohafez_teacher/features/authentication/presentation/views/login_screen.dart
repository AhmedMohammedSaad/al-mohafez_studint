import 'package:almohafez/almohafez/core/presentation/view/main_screen.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/almohafez/core/routing/app_route.dart';
import 'package:almohafez/almohafez/core/services/navigation_service/global_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/features/authentication/presentation/views/sign_up_screen.dart';
import 'package:almohafez/almohafez/core/data/local_data/caching_helper.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                SizedBox(height: 20.h),
                AppCustomImageView(
                  imagePath: 'assets/images/logo_almohafz.png',
                  width: 180.w,
                  height: 100.h,
                ),
                // Header
                AuthHeader(
                  title: 'welcome_back'.tr(),
                  subtitle: 'sign_in_to_continue'.tr(),
                ),

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
                  hintText: 'enter_your_password'.tr(),
                  controller: _passwordController,
                  isPassword: true,
                  isRequired: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  validator: _validatePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                ),

                SizedBox(height: 16.h),

                // Remember Me & Forgot Password Row
                Row(
                  children: [
                    // Remember Me Checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primaryBlueViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'remember_me'.tr(),
                          style: AppTextStyle.medium14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // const Spacer(),

                    // // Forgot Password
                    // GestureDetector(
                    //   onTap: _navigateToForgotPassword,
                    //   child: Text(
                    //     'forgot_password'.tr(),
                    //     style: AppTextStyle.medium14.copyWith(
                    //       color: AppColors.primaryBlueViolet,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Login Button
                AuthButton(
                  text: 'sign_in'.tr(),
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 24.h),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.borderLight,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'or_continue_with'.tr(),
                        style: AppTextStyle.medium14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.borderLight,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Social Login Buttons
                SocialLoginButton(
                  type: SocialLoginType.google,
                  onPressed: _handleGoogleLogin,
                  customText: 'continue_with_google'.tr(),
                ),

                SizedBox(height: 32.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dont_have_account'.tr(),
                      style: AppTextStyle.medium14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: _navigateToSignUp,
                      child: Text(
                        'sign_up'.tr(),
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
    if (value.length < 6) {
      return 'password_too_short'.tr();
    }
    return null;
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      // Cache dummy tokens until API integration
      await AppCacheHelper.cacheSecureString(
        key: AppCacheHelper.accessTokenKey,
        value: 'dummy_access_${DateTime.now().millisecondsSinceEpoch}',
      );
      await AppCacheHelper.cacheSecureString(
        key: AppCacheHelper.refreshTokenKey,
        value: 'dummy_refresh_${DateTime.now().millisecondsSinceEpoch}',
      );

      // // Save user email if remember me is checked
      // if (_rememberMe) {
      //   await AppCacheHelper.saveString('user_email', _emailController.text);
      // }
      NavigationService.goTo(AppRouter.kMainScreen);
      // Navigate to main app or dashboard
      // if (mounted) {
      // NavigationService.goTo(AppRouter.kMainScreen);
      // }
    } catch (e) {
      // TODO: Handle login error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('login_failed'.tr()),
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

  void _handleGoogleLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );

    try {
      // Save login state for Google login
      // await AppCacheHelper.saveSecureString('access_token', 'google_token_${DateTime.now().millisecondsSinceEpoch}');
      // await AppCacheHelper.saveBool('is_logged_in', true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('login_failed'.tr()),
            backgroundColor: AppColors.primaryError,
          ),
        );
      }
    }
  }

  // void _navigateToForgotPassword() {
  //   NavigationService.goTo(AppRouter.kForgotPasswordScreen);
  // }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
}
