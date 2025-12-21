import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

class BannerCarouselWidget extends StatefulWidget {
  const BannerCarouselWidget({super.key});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _bannerMessages = [
    'banner_message_1'.tr(),
    'banner_message_2'.tr(),
    'banner_message_3'.tr(),
    'banner_message_4'.tr(),
    // 'banner_message_5'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoCarousel();
  }

  void _startAutoCarousel() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex < _bannerMessages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // البانر الرئيسي
        Container(
          height: 140.h, // زيادة الارتفاع من 120 إلى 140
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A1D64), // الأزرق الداكن الأساسي للتطبيق
                Color(0xFF1E3A8A), // أزرق متوسط
                Color(0xFF059669), // أخضر جميل
                Color(0xFF10B981), // أخضر فاتح
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A1D64).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _bannerMessages.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    // الشعار في الجانب الأيسر
                    AppCustomImageView(
                      imagePath: 'assets/images/logo_almohafz-Photoroom.png',
                      fit: BoxFit.contain,
                      //  width: 150.w,
                      height: 130.h,
                    ),

                    SizedBox(width: 5.w),

                    // النص في الجهة اليمنى
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _bannerMessages[index],
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              // height: 1.3,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            width: 40.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        SizedBox(height: 8.h), // مسافة بين البانر والمؤشرات
        // مؤشرات الصفحات خارج البانر
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerMessages.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? const Color(0xFF0A1D64)
                    : const Color(0xFF0A1D64).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
