import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/presentation/view/widgets/app_custom_image_view.dart';

class BannerCarouselWidget extends StatefulWidget {
  const BannerCarouselWidget({super.key});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  int _currentIndex = 0;

  final List<String> _bannerMessages = [
    'banner_message_1'.tr(),
    'banner_message_2'.tr(),
    'banner_message_3'.tr(),
    'banner_message_4'.tr(),
    // 'banner_message_5'.tr(),
  ];

  // Gradients for each banner card to add variety (Nano Banana Style: Vibrant & distinct)
  final List<List<Color>> _bannerGradients = [
    [const Color(0xFF0A1D64), const Color(0xFF1E3A8A)], // Blue
    [const Color(0xFF0F5132), const Color(0xFF198754)], // Dark Green
    [const Color(0xFFB91C1C), const Color(0xFFEF4444)], // Red (Alert/Important)
    [const Color(0xFF0284C7), const Color(0xFF38BDF8)], // Light Blue
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _bannerMessages.length,
          itemBuilder: (context, index, realIndex) {
            final gradient = _bannerGradients[index % _bannerGradients.length];
            return _buildBannerCard(
              message: _bannerMessages[index],
              gradientColors: gradient,
            );
          },
          options: CarouselOptions(
            height: 130.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95, // Slightly show next card
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        SizedBox(height: 12.h),

        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _bannerMessages.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 20.w : 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: _currentIndex == entry.key
                    ? const Color(0xFF0A1D64)
                    : const Color(0xFF0A1D64).withValues(alpha: 0.2),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerCard({
    required String message,
    required List<Color> gradientColors,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern (Circles)
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Image
                Hero(
                  tag: 'banner_logo_$message', // Simplified tag
                  child: AppCustomImageView(
                    imagePath: 'assets/images/logo_almohafz-Photoroom.png',
                    fit: BoxFit.contain,
                    height: 100.h,
                    width: 100.w,
                  ),
                ),

                SizedBox(width: 12.w),

                // Text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Small indicator bar
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
