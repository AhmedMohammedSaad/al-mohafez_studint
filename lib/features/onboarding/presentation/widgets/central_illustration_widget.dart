import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/core/presentation/view/widgets/app_custom_image_view.dart';

class CentralIllustrationWidget extends StatelessWidget {
  const CentralIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // دوائر الاتصال الخلفية
          _buildConnectionCircles(),

          // الهاتف الذكي في المنتصف
          _buildSmartphone(),

          // شخصية الطالب (يمين)
          Positioned(right: -1.w, child: _buildStudentPersona()),

          // شخصية المحفظ (يسار)
          Positioned(left: -1.w, child: _buildTeacherPersona()),
        ],
      ),
    );
  }

  Widget _buildConnectionCircles() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // الدائرة الأولى
        Container(
          width: 200.w,
          height: 200.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
        // الدائرة الثانية
        Container(
          width: 160.w,
          height: 160.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmartphone() {
    return Container(
      width: 75.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AppCustomImageView(
        imagePath: 'assets/images/logo_almohafz.png',
        width: 100.w,
        height: 100.w,
      ),
    );
  }

  Widget _buildStudentPersona() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.school_rounded,
          color: const Color(0xFF3B82F6),
          size: 30.sp,
        ),
      ),
    );
  }

  Widget _buildTeacherPersona() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: const Color(0xFF14B8A6),
          size: 30.sp,
        ),
      ),
    );
  }
}
