import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/evaluations_stats_widget.dart';

class TestEvaluationsPage extends StatelessWidget {
  const TestEvaluationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية لتقييمات الطلاب
    final List<StudentEvaluation> sampleEvaluations = [
      StudentEvaluation(
        studentName: 'أحمد محمد',
        rating: 5,
        comment:
            'الشيخ ممتاز في التدريس ويشرح بطريقة واضحة ومفهومة. استفدت كثيراً من دروسه في الحفظ والتجويد.',
        evaluationDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      StudentEvaluation(
        studentName: 'فاطمة أحمد',
        rating: 4,
        comment:
            'أسلوب الشيخ في التدريس جيد جداً، لكن أتمنى لو يعطي وقت أكثر للأسئلة.',
        evaluationDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      StudentEvaluation(
        studentName: 'عبدالله سالم',
        rating: 5,
        comment: 'مجتهد',
        evaluationDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      StudentEvaluation(
        studentName: 'مريم خالد',
        rating: 4,
        comment:
            'الشيخ صبور ومتفهم، ويساعد الطلاب على تحسين مستواهم في التلاوة والحفظ.',
        evaluationDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
      StudentEvaluation(
        studentName: 'يوسف عمر',
        rating: 3,
        comment: 'الدروس مفيدة ولكن أحياناً تكون سريعة قليلاً.',
        evaluationDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      StudentEvaluation(
        studentName: 'عائشة محمود',
        rating: 5,
        comment:
            'الشيخ رائع في تعليم التجويد وتصحيح الأخطاء. أنصح جميع الطلاب بحضور دروسه.',
        evaluationDate: DateTime.now().subtract(const Duration(days: 6)),
      ),
      StudentEvaluation(
        studentName: 'حسام علي',
        rating: 4,
        comment: 'استفدت كثيراً من الدروس، والشيخ يهتم بكل طالب على حدة.',
        evaluationDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.grey.withOpacity(0.05),
      appBar: AppBar(
        title: Text(
          'تقييمات الطلاب للشيخ',
          style: AppTextStyle.textStyle18.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primaryBlueViolet,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // معلومات إضافية
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryBlueViolet,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'هذه صفحة تجريبية لعرض تقييمات الطلاب للشيخ',
                      style: AppTextStyle.textStyle14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ويدجت التقييمات الجديد
            EvaluationsStatsWidget(studentEvaluations: sampleEvaluations),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
