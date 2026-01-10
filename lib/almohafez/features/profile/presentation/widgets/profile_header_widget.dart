import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;
  final VoidCallback? onEdit;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar would go here if uncommented
        Container(
          width: 60.w,
          height: 60.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF3F4F6),
          ),
          child: Icon(
            Icons.person,
            size: 30.sp,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName.isNotEmpty ? fullName : 'profile_user_name'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                email.isNotEmpty ? email : 'profile_user_email'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        // Edit Icon
        InkWell(
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.edit_outlined,
              size: 20.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }
}
