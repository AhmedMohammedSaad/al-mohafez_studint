import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/progress_model.dart';

class EvaluationsListWidget extends StatelessWidget {
  final List<RecentSession> evaluations;

  const EvaluationsListWidget({super.key, required this.evaluations});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'progress_evaluations_history'
                    .tr(), // You might need to add this key or reuse existing
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E3A59),
                ),
              ),
              const Spacer(),
              Text(
                '📝',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF8C8C8C),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (evaluations.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: evaluations.length,
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                return _EvaluationCard(session: evaluations[index]);
              },
            )
          else
            SizedBox(
              height: 100.h,
              child: Center(
                child: Text(
                  'progress_no_evaluations'
                      .tr(), // Ensure this key exists or fallback
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF8C8C8C),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final RecentSession session;

  const _EvaluationCard({required this.session});

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('d MMMM yyyy', 'ar');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(session.date),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE5E5E5),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),

          // Teacher name section
          Expanded(
            flex: 3,
            child: Text(
              session.teacherName,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2C2C2C),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE5E5E5),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),

          // Rating section
          Expanded(
            flex: 2,
            child: _StarRating(
              rating: session.rating,
              maxRating: session.maxRating,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final int maxRating;

  const _StarRating({required this.rating, required this.maxRating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating
              ? const Color(0xFFFFD700)
              : const Color(0xFFE0E0E0),
          size: 11.sp,
        );
      }),
    );
  }
}
