import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

/// A reusable error widget that displays an error message with a refresh button.
///
/// This widget is used across the app to show consistent error states
/// in screens like Sessions, Profile, and Students.
class AppErrorWidget extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Callback function when the refresh button is pressed.
  final VoidCallback onRefresh;

  /// Optional title for the error. Defaults to "حدث خطأ".
  final String? title;

  /// Optional icon to display. Defaults to error_outline.
  final IconData? icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRefresh,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primaryError.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 48.sp,
                color: AppColors.primaryError,
              ),
            ),

            SizedBox(height: 24.h),

            // Error title
            Text(
              title ?? 'حدث خطأ',
              style: AppTextStyle.textStyle18Bold.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // Error message
            Text(
              message,
              style: AppTextStyle.textStyle14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 32.h),

            // Refresh button
            ElevatedButton.icon(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlueViolet,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text(
                'إعادة المحاولة',
                style: AppTextStyle.textStyle16Medium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
