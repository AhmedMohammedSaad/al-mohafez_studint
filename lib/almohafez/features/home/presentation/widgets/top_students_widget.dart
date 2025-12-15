import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class TopStudentsWidget extends StatelessWidget {
  const TopStudentsWidget({super.key});

  // بيانات وهمية للطلاب
  final List<Map<String, dynamic>> _topStudents = const [
    {'name': 'محمد أحمد', 'progress': 0.95, 'rank': 1},
    {'name': 'فاطمة علي', 'progress': 0.88, 'rank': 2},
    {'name': 'عبدالله محمد', 'progress': 0.82, 'rank': 3},
    {'name': 'عائشة حسن', 'progress': 0.78, 'rank': 4},
    {'name': 'يوسف إبراهيم', 'progress': 0.75, 'rank': 5},
    {'name': 'زينب أحمد', 'progress': 0.72, 'rank': 6},
    {'name': 'عمر خالد', 'progress': 0.68, 'rank': 7},
    {'name': 'مريم سالم', 'progress': 0.65, 'rank': 8},
    {'name': 'حسام محمود', 'progress': 0.62, 'rank': 9},
    {'name': 'نور الهدى', 'progress': 0.58, 'rank': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
            'top_students_title'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
          ),

        SizedBox(height: 15.h),

        // قائمة الطلاب الأفقية
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _topStudents.length,
            itemBuilder: (context, index) {
              final student = _topStudents[index];
              return Container(
                width: 90.w,
                margin: EdgeInsets.only(right: 12.w),
                child: Column(
                  children: [
                    // صورة الطالب مع دائرة التقدم
                    SizedBox(height: 7.h),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // دائرة التقدم
                        SizedBox(
                          width: 70.w,
                          height: 70.h,
                          child: CircularProgressIndicator(
                            value: student['progress'],
                            strokeWidth: 3,
                            backgroundColor: const Color(
                              0xFF00E0FF,
                            ).withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF00E0FF),
                            ),
                          ),
                        ),

                        // صورة الطالب
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF0A1D64).withOpacity(0.1),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 30.sp,
                            color: const Color(0xFF0A1D64),
                          ),
                        ),

                        // رقم الترتيب
                        if (student['rank'] <= 3)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: student['rank'] == 1
                                    ? const Color(0xFFFFD700)
                                    : student['rank'] == 2
                                    ? const Color(0xFFC0C0C0)
                                    : const Color(0xFFCD7F32),
                              ),
                              child: Center(
                                child: Text(
                                  '${student['rank']}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // اسم الطالب
                    Text(
                      student['name'],
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0A1D64),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
