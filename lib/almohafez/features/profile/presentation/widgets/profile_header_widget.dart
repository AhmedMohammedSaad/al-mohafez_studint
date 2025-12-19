import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // صورة دائرية كبيرة (90px)
          // Container(
          //   width: 90.w,
          //   height: 90.w,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     border: Border.all(
          //       color: const Color(0xFF0A1D64).withValues(alpha: 0.1),
          //       width: 3,
          //     ),
          //   ),
          //   child: CircleAvatar(
          //     radius: 45.r,
          //     backgroundColor: const Color(0xFF0A1D64).withValues(alpha: 0.1),
          //     backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
          //         ? NetworkImage(avatarUrl!) as ImageProvider
          //         : const AssetImage('assets/images/placeholder.webp'),
          //   ),
          // ),
          // SizedBox(height: 16.h),
          // الاسم: Bold، حجم 20px، لون #0A1D64
          Text(
            fullName.isNotEmpty ? fullName : 'profile_user_name'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
          ),
          SizedBox(height: 8.h),
          // البريد الإلكتروني: خط رمادي متوسط
          Text(
            email.isNotEmpty ? email : 'profile_user_email'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
