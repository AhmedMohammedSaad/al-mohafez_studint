import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/tutor_model.dart';

class TutorCard extends StatelessWidget {
  final TutorModel tutor;
  final VoidCallback onTap;

  const TutorCard({super.key, required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF00E0FF).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة المحفظ
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFF00E0FF).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: tutor.profilePictureUrl.isNotEmpty
                    ? Image.network(
                        tutor.profilePictureUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            tutor.gender == 'male'
                                ? 'assets/images/shaegh.jpg'
                                : 'assets/images/niqab-5.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        tutor.gender == 'male'
                            ? 'assets/images/shaegh.jpg'
                            : 'assets/images/niqab-5.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: 16.w),
            // معلومات المحفظ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم وحالة التوفر
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tutor.fullName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0A1D64),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildAvailabilityBadge(),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // التقييم
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFFFB800),
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        tutor.overallRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A1D64),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.school,
                        color: const Color(0xFF5B6C9F),
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'teachers_sessions_count'.tr(
                          namedArgs: {'count': tutor.numSessions.toString()},
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF5B6C9F),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // المؤهلات (أول مؤهل فقط)
                  if (tutor.qualifications.isNotEmpty)
                    Text(
                      tutor.qualifications.first,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF5B6C9F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // سهم للانتقال
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF00E0FF),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: tutor.isAvailable
            ? const Color(0xFF4CAF50).withOpacity(0.1)
            : const Color(0xFFFF6B6B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        tutor.isAvailable
            ? 'teachers_available'.tr()
            : 'teachers_unavailable'.tr(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: tutor.isAvailable
              ? const Color(0xFF4CAF50)
              : const Color(0xFFFF6B6B),
        ),
      ),
    );
  }
}
