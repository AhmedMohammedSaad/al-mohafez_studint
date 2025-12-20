import 'package:almohafez/almohafez_teacher/features/evaluations/presentation/widgets/evaluations_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/evaluation_model.dart';
import '../../../students/data/models/student_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class EvaluationsScreen extends StatefulWidget {
  const EvaluationsScreen({super.key});

  @override
  State<EvaluationsScreen> createState() => _EvaluationsScreenState();
}

class _EvaluationsScreenState extends State<EvaluationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'التقييمات',
          style: AppTextStyle.textStyle20.copyWith(
            color: AppColors.primaryBlueViolet,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // actions: [
        // IconButton(
        // onPressed: () {
        // Handle search
        // },
        // icon: Icon(
        // Icons.search,
        // color: AppColors.primaryBlueViolet,
        // size: 24.sp,
        // ),
        // ),
        // ],
      ),
      body: Column(
        children: [
          // Statistics - Student Evaluations for Sheikh
          EvaluationsStatsWidget(
            studentEvaluations: _getSampleStudentEvaluations(),
          ),
          SizedBox(height: 16.h),
          //
          // Filters
          // EvaluationsFilterWidget(
          // selectedFilter: _selectedFilter,
          // selectedStudent: _selectedStudent,
          // filterOptions: _filterOptions,
          // students: _students,
          // onFilterChanged: (filter) {
          // setState(() {
          // _selectedFilter = filter;
          // });
          // },
          // onStudentChanged: (student) {
          // setState(() {
          // _selectedStudent = student;
          // });
          // },
          // ),
          //
          // SizedBox(height: 16.h),
          //
          // Evaluations List
          // Expanded(
          // child: _filteredEvaluations.isEmpty
          // ? _buildEmptyState()
          // : ListView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 16.w),
          // itemCount: _filteredEvaluations.length,
          // itemBuilder: (context, index) {
          // final evaluation = _filteredEvaluations[index];
          // return Padding(
          // padding: EdgeInsets.only(bottom: 12.h),
          // child: EvaluationCardWidget(
          // evaluation: evaluation,
          // onTap: () => _handleEvaluationTap(evaluation),
          // ),
          // );
          // },
          // ),
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      // onPressed: () {
      // Navigate to add evaluation screen
      // },
      // backgroundColor: AppColors.primaryBlueViolet,
      // child: Icon(Icons.add, color: AppColors.white, size: 24.sp),
      // ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment_outlined, size: 80.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'لا توجد تقييمات',
            style: AppTextStyle.textStyle18.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'لم يتم العثور على تقييمات تطابق المعايير المحددة',
            style: AppTextStyle.textStyle14.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleEvaluationTap(Evaluation evaluation) {
    // Navigate to evaluation details screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تفاصيل التقييم',
          style: AppTextStyle.textStyle18.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlueViolet,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الطالب: ${evaluation.studentName}'),
            Text(
              'التاريخ: ${DateFormat('dd/MM/yyyy', 'ar').format(evaluation.evaluationDate)}',
            ),
            Text(
              'المتوسط العام: ${evaluation.averageScore.toStringAsFixed(1)}/10',
            ),
            if (evaluation.notes != null && evaluation.notes!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text('الملاحظات: ${evaluation.notes!}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  // دالة للحصول على بيانات تجريبية لتقييمات الطلاب للشيخ
  List<StudentEvaluation> _getSampleStudentEvaluations() {
    return [
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
    ];
  }
}
