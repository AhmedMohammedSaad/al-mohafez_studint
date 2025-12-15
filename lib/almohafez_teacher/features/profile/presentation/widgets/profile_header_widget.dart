import 'dart:io';

import 'package:almohafez/almohafez_teacher/features/profile/data/models/local_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalUserModel? user = AppConst.userProfile;
    final String displayName = user != null
        ? '${user.firstName} ${user.lastName}'.trim()
        : 'profile_user_name'.tr();
    final String displayEmail = user?.email ?? 'profile_user_email'.tr();
    final String? imagePath = user?.profileImagePath;

    return Container(
      padding: EdgeInsets.all(24.w),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // صورة دائرية كبيرة (90px)
          Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0A1D64).withOpacity(0.1),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 45.r,
              backgroundColor: const Color(0xFF0A1D64).withOpacity(0.1),
              backgroundImage: imagePath != null && imagePath.isNotEmpty
                  ? FileImage(File(imagePath))
                  : const AssetImage('assets/images/placeholder.webp'),
            ),
          ),
          SizedBox(height: 16.h),
          // الاسم: Bold، حجم 20px، لون #0A1D64
          Text(
            displayName,
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
            displayEmail,
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
