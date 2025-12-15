import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/tutor_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF00E0FF).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات المراجع والتقييم
          Row(
            children: [
              // أيقونة المراجع
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF00E0FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.person,
                  color: const Color(0xFF00E0FF),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              // اسم المراجع
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewer,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0A1D64),
                      ),
                    ),
                    // SizedBox(height: 2.h),
                    // Text(
                    //   _formatDate(review.date),
                    //   style: TextStyle(
                    //     fontFamily: 'Cairo',
                    //     fontSize: 12.sp,
                    //     color: const Color(0xFF5B6C9F),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // التقييم
              _buildRatingStars(),
            ],
          ),
          SizedBox(height: 12.h),
          // نص المراجعة
          Text(
            review.comment,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              color: const Color(0xFF5B6C9F),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < review.rating.floor()
              ? Icons.star
              : index < review.rating
              ? Icons.star_half
              : Icons.star_border,
          color: const Color(0xFFFFB800),
          size: 16.sp,
        );
      }),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'reviews_date_today'.tr();
      } else if (difference.inDays == 1) {
        return 'reviews_date_yesterday'.tr();
      } else if (difference.inDays < 7) {
        return 'reviews_date_days_ago'.tr(
          namedArgs: {'days': difference.inDays.toString()},
        );
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1
            ? 'reviews_date_week_ago'.tr(namedArgs: {'weeks': weeks.toString()})
            : 'reviews_date_weeks_ago'.tr(
                namedArgs: {'weeks': weeks.toString()},
              );
      } else {
        final months = (difference.inDays / 30).floor();
        return months == 1
            ? 'reviews_date_month_ago'.tr(
                namedArgs: {'months': months.toString()},
              )
            : 'reviews_date_months_ago'.tr(
                namedArgs: {'months': months.toString()},
              );
      }
    } catch (e) {
      return dateString;
    }
  }
}
