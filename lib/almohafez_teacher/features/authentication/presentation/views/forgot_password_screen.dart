import 'package:almohafez/almohafez/core/routing/app_route.dart';
import 'package:almohafez/almohafez/core/services/navigation_service/global_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../../../core/routing/app_route.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),

              // Header
              AuthHeader(
                title: _emailSent
                    ? 'check_your_email'.tr()
                    : 'forgot_password'.tr(),
                subtitle: _emailSent
                    ? 'reset_link_sent'.tr()
                    : 'enter_email_to_reset'.tr(),
                showBackButton: true,
                onBackPressed: () => NavigationService.goBack(),
                logo: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: _emailSent
                        ? AppColors.primarySuccess
                        : AppColors.primaryBlueViolet,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                    color: AppColors.primaryWhite,
                    size: 32.sp,
                  ),
                ),
              ),

              if (!_emailSent) ...[
                // Email Input Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleSendResetLink(),
                      ),

                      SizedBox(height: 32.h),

                      // Send Reset Link Button
                      AuthButton(
                        text: 'send_reset_link'.tr(),
                        onPressed: _handleSendResetLink,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 24.h),

                      // Instructions
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCard,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1,
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
                                  'instructions'.tr(),
                                  style: AppTextStyle.semiBold16.copyWith(
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'reset_password_instructions'.tr(),
                              style: AppTextStyle.medium14.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Email Sent Success State
                Column(
                  children: [
                    // Success Illustration
                    Container(
                      width: 120.w,
                      height: 120.h,
                      margin: EdgeInsets.symmetric(vertical: 32.h),
                      decoration: BoxDecoration(
                        color: AppColors.primarySuccess.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mark_email_read,
                        color: AppColors.primarySuccess,
                        size: 60.sp,
                      ),
                    ),

                    // Success Message
                    Text(
                      'reset_email_sent_message'.tr(),
                      style: AppTextStyle.medium16.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32.h),

                    // Open Email App Button
                    AuthButton(
                      text: 'open_email_app'.tr(),
                      onPressed: _openEmailApp,
                      type: AuthButtonType.primary,
                    ),

                    SizedBox(height: 16.h),

                    // Resend Email Button
                    AuthButton(
                      text: 'resend_email'.tr(),
                      onPressed: _resendEmail,
                      type: AuthButtonType.outline,
                    ),

                    SizedBox(height: 24.h),

                    // Didn't receive email?
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCard,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'didnt_receive_email'.tr(),
                            style: AppTextStyle.semiBold14.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'check_spam_folder'.tr(),
                            style: AppTextStyle.medium14.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 32.h),

              // Back to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryBlueViolet,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: Text(
                      'back_to_login'.tr(),
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

  void _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual password reset logic
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _emailSent = true;
        });
      }
    } catch (e) {
      // TODO: Handle password reset error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('reset_link_failed'.tr()),
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

  void _openEmailApp() {
    // TODO: Implement opening email app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('opening_email_app'.tr()),
        backgroundColor: AppColors.primaryBlueViolet,
      ),
    );
  }

  void _resendEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement resend email logic
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('reset_email_resent'.tr()),
            backgroundColor: AppColors.primarySuccess,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('resend_failed'.tr()),
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
    NavigationService.goTo(AppRouter.kLoginScreen);
  }
}
