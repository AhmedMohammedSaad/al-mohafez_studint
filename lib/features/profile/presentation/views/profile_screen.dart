import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'الحساب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A1D64),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 80.sp,
              color: const Color(0xFF00E0FF),
            ),
            SizedBox(height: 20.h),
            Text(
              'الملف الشخصي',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A1D64),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'هنا ستجد معلوماتك الشخصية والإعدادات',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                color: const Color(0xFF5B6C9F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}