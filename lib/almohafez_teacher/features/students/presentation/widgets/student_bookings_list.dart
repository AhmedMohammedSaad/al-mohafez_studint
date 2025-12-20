import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class StudentBookingsList extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;

  const StudentBookingsList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('سجل الجلسات', style: AppTextStyle.font16DarkBlueBold),
          SizedBox(height: 16.h),

          Expanded(
            child: bookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildBookingCard(bookings[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text('لا توجد جلسات سابقة', style: AppTextStyle.font14GreyRegular),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    // Parse date safely
    DateTime? date;
    if (booking['selected_date'] != null) {
      date = DateTime.tryParse(booking['selected_date']);
    }

    final status = booking['status'] ?? 'pending';
    final notes = booking['notes'];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGrayConstant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // التاريخ والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null
                    ? DateFormat('dd/MM/yyyy').format(date)
                    : 'بدون تاريخ',
                style: AppTextStyle.font12GreyMedium,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _getStatusText(status),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),

          if (notes != null && notes.toString().isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text('الملاحظات:', style: AppTextStyle.font12GreyMedium),
            SizedBox(height: 4.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrayConstant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                notes.toString(),
                style: AppTextStyle.font12DarkBlueRegular,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتملة';
      case 'confirmed':
        return 'مؤكدة';
      case 'cancelled':
        return 'ملغاة';
      case 'pending':
        return 'قيد الانتظار';
      default:
        return status;
    }
  }
}
