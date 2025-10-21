import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/tutor_model.dart';
import '../../data/models/tutors_response_model.dart';
import '../../data/mock_data/tutors_mock_data.dart';
import '../widgets/tutor_card.dart';
import 'tutor_profile_screen.dart';

class TutorsListScreen extends StatefulWidget {
  final String gender;

  const TutorsListScreen({super.key, required this.gender});

  @override
  State<TutorsListScreen> createState() => _TutorsListScreenState();
}

class _TutorsListScreenState extends State<TutorsListScreen> {
  late TutorsResponseModel tutorsResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTutors();
  }

  void _loadTutors() {
    setState(() {
      isLoading = true;
    });

    // محاكاة تحميل البيانات
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        tutorsResponse = TutorsMockData.getTutorsByGender(widget.gender);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'teachers'.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A1D64),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF0A1D64),
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? _buildLoadingWidget()
          : tutorsResponse.hasError
          ? _buildErrorWidget()
          : tutorsResponse.isEmpty
          ? _buildEmptyWidget()
          : _buildTutorsList(),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: const Color(0xFF00E0FF),
            strokeWidth: 3.w,
          ),
          SizedBox(height: 20.h),
          Text(
            'teachers_loading_message'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              color: const Color(0xFF5B6C9F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.sp,
              color: const Color(0xFFFF6B6B),
            ),
            SizedBox(height: 20.h),
            Text(
              tutorsResponse.errorMessage ?? 'teachers_error_unexpected'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                color: const Color(0xFF5B6C9F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: _loadTutors,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E0FF),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'teachers_retry_button'.tr(),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80.sp, color: const Color(0xFF5B6C9F)),
            SizedBox(height: 20.h),
            Text(
              'teachers_empty_title'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0A1D64),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'teachers_empty_subtitle'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: const Color(0xFF5B6C9F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorsList() {
    return Column(
      children: [
        // عداد المحفظين
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF00E0FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            'teachers_found_count'.tr(
              namedArgs: {'count': tutorsResponse.tutors.length.toString()},
            ),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0A1D64),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // قائمة المحفظين
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: tutorsResponse.tutors.length,
            itemBuilder: (context, index) {
              final tutor = tutorsResponse.tutors[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: TutorCard(
                  tutor: tutor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorProfileScreen(tutor: tutor),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
