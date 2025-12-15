import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/models/tutor_model.dart';
import '../../logic/pricing_plans_cubit.dart';
import '../../data/repos/pricing_plans_repo.dart';
import '../widgets/review_card.dart';
import '../widgets/booking_bottom_sheet.dart';

class TutorProfileScreen extends StatelessWidget {
  final TutorModel tutor;

  const TutorProfileScreen({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar مع الصورة
              SliverAppBar(
                expandedHeight: 280.h,
                pinned: true,
                backgroundColor: const Color(0xFF0A1D64),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0A1D64), Color(0xFF00E0FF)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60.h),
                        // صورة المحفظ
                        Container(
                          width: 120.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
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
                        SizedBox(height: 16.h),
                        // اسم المحفظ
                        Text(
                          tutor.fullName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // التقييم وحالة التوفر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: const Color(0xFFFFB800),
                              size: 20.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              tutor.overallRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: tutor.isAvailable
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFFF6B6B),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                tutor.isAvailable
                                    ? 'teachers_available'.tr()
                                    : 'teachers_unavailable'.tr(),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // محتوى الصفحة
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // إحصائيات سريعة
                      _buildStatsSection(),
                      SizedBox(height: 24.h),
                      // النبذة التعريفية
                      _buildBioSection(),
                      SizedBox(height: 24.h),
                      // المؤهلات
                      _buildQualificationsSection(),
                      SizedBox(height: 24.h),
                      // أوقات التوفر
                      _buildAvailabilitySection(),
                      SizedBox(height: 24.h),
                      // وسائل التواصل
                      // _buildContactMethodsSection(),
                      // SizedBox(height: 24.h),
                      // المراجعات
                      _buildReviewsSection(),
                      SizedBox(height: 300.h), // مساحة إضافية لزر الحجز
                    ],
                  ),
                ),
              ),
            ],
          ),

          // زر الحجز
          if (tutor.isAvailable)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: () {
                      _showBookingBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E0FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'tutor_profile_book_session'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => PricingPlansCubit(PricingPlansRepo()),
        child: BookingBottomSheet(tutor: tutor),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.school,
            title: 'tutor_profile_sessions_count'.tr(),
            value: tutor.numSessions.toString(),
            color: const Color(0xFF00E0FF),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            title: 'tutor_profile_rating'.tr(),
            value: tutor.overallRating.toStringAsFixed(1),
            color: const Color(0xFFFFB800),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.reviews,
            title: 'tutor_profile_reviews'.tr(),
            value: tutor.reviews.length.toString(),
            color: const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: const Color(0xFF5B6C9F),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return _buildSection(
      title: 'tutor_profile_bio'.tr(),
      icon: Icons.info_outline,
      child: Text(
        tutor.bio,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14.sp,
          color: const Color(0xFF5B6C9F),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildQualificationsSection() {
    return _buildSection(
      title: 'tutor_profile_qualifications'.tr(),
      icon: Icons.school_outlined,
      child: Column(
        children: tutor.qualifications.map((qualification) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF4CAF50),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    qualification,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: const Color(0xFF5B6C9F),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return _buildSection(
      title: 'tutor_profile_availability'.tr(),
      icon: Icons.schedule,
      child: tutor.availabilitySlots.isEmpty
          ? Text(
              'teachers_no_available_times'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: const Color(0xFF5B6C9F),
                fontStyle: FontStyle.italic,
              ),
            )
          : Column(
              children: tutor.availabilitySlots.map((slot) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E0FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: const Color(0xFF00E0FF),
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        slot.day,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A1D64),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${slot.start} - ${slot.end}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                          color: const Color(0xFF5B6C9F),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildContactMethodsSection() {
    return _buildSection(
      title: 'tutor_profile_contact_methods'.tr(),
      icon: Icons.contact_phone,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: tutor.contactMethods.map((method) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getContactIcon(method),
                  color: const Color(0xFF4CAF50),
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  method,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return _buildSection(
      title: 'tutor_profile_student_reviews'.tr(),
      icon: Icons.rate_review,
      child: tutor.reviews.isEmpty
          ? Text(
              'tutor_profile_no_reviews'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: const Color(0xFF5B6C9F),
                fontStyle: FontStyle.italic,
              ),
            )
          : Column(
              children: tutor.reviews.map((review) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ReviewCard(review: review),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0A1D64), size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A1D64),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }

  IconData _getContactIcon(String method) {
    switch (method.toLowerCase()) {
      case 'whatsapp':
      case 'واتساب':
        return Icons.chat;
      case 'voice_call':
      case 'مكالمة صوتية':
        return Icons.phone;
      case 'video_call':
      case 'مكالمة فيديو':
        return Icons.videocam;
      case 'telegram':
      case 'تيليجرام':
        return Icons.telegram;
      case 'email':
      case 'إيميل':
        return Icons.email;
      default:
        return Icons.contact_phone;
    }
  }
}
