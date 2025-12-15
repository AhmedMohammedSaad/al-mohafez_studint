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
  String _selectedFilter = 'الكل';
  String _selectedStudent = 'الكل';
  final List<String> _filterOptions = [
    'الكل',
    'ممتاز',
    'جيد جداً',
    'جيد',
    'مقبول',
    'يحتاج تحسين',
  ];

  // Dummy data
  final List<Evaluation> _evaluations = [
    Evaluation(
      id: '1',
      sessionId: 'session1',
      studentId: 'student1',
      studentName: 'أحمد محمد',
      evaluationDate: DateTime.now().subtract(const Duration(days: 1)),
      memorizationScore: 8.5,
      tajweedScore: 9.0,
      notes: 'أداء ممتاز في الحفظ والتجويد',
      strengths: 'سرعة في الحفظ، إتقان أحكام التجويد',
      improvements: 'تحسين الوقف والابتداء',
      nextSessionGoals: 'حفظ صفحة جديدة من سورة البقرة',
      topics: ['سورة البقرة، أحكام التجويد'],
      isCompleted: true,
      overallPerformance: 8.5,
    ),
    Evaluation(
      id: '2',
      sessionId: 'session2',
      studentId: 'student2',
      studentName: 'فاطمة علي',
      evaluationDate: DateTime.now().subtract(const Duration(days: 2)),
      memorizationScore: 7.0,
      tajweedScore: 7.5,
      overallPerformance: 7.0,
      notes: 'أداء جيد مع بعض التحسينات المطلوبة',
      strengths: 'التزام بالحضور، حماس للتعلم',
      improvements: 'تحسين المخارج، زيادة وقت المراجعة',
      nextSessionGoals: 'مراجعة الحفظ السابق وإضافة آيات جديدة',
      topics: ['سورة آل عمران، المدود'],
      isCompleted: true,
    ),
    Evaluation(
      id: '3',
      sessionId: 'session3',
      studentId: 'student3',
      studentName: 'عبدالله أحمد',
      evaluationDate: DateTime.now().subtract(const Duration(days: 3)),
      memorizationScore: 9.5,
      tajweedScore: 9.0,
      overallPerformance: 9.2,
      notes: 'أداء استثنائي ومتميز',
      strengths: 'حفظ قوي، تجويد ممتاز، فهم عميق',
      improvements: 'الاستمرار على نفس المستوى',
      nextSessionGoals: 'البدء في حفظ سورة جديدة',
      topics: ['سورة النساء، الإدغام والإقلاب'],
      isCompleted: true,
    ),
  ];

  final List<Student> _students = [
    Student(
      id: 'student1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      phone: '+966501234567',
      level: 'متوسط',
      currentPart: 'الجزء الخامس',
      completedParts: [
        'الجزء الأول',
        'الجزء الثاني',
        'الجزء الثالث',
        'الجزء الرابع',
      ],
      joinDate: DateTime.now().subtract(const Duration(days: 180)),
      isActive: true,
      profileImage: null,
      averageRating: 8.5,
      totalSessions: 45,
      notes: 'طالب متميز ومجتهد',
    ),
    Student(
      id: 'student2',
      name: 'فاطمة علي',
      email: 'fatima@example.com',
      phone: '+966507654321',
      level: 'مبتدئ',
      currentPart: 'الجزء الثاني',
      completedParts: ['الجزء الأول'],
      joinDate: DateTime.now().subtract(const Duration(days: 90)),
      isActive: true,
      profileImage: null,
      averageRating: 7.2,
      totalSessions: 25,
      notes: 'طالبة مجتهدة تحتاج المزيد من التشجيع',
    ),
    Student(
      id: 'student3',
      name: 'عبدالله أحمد',
      email: 'abdullah@example.com',
      phone: '+966509876543',
      level: 'متقدم',
      currentPart: 'الجزء الخامس عشر',
      completedParts: [
        'الجزء الأول',
        'الجزء الثاني',
        'الجزء الثالث',
        'الجزء الرابع',
        'الجزء الخامس',
        'الجزء السادس',
        'الجزء السابع',
        'الجزء الثامن',
        'الجزء التاسع',
        'الجزء العاشر',
        'الجزء الحادي عشر',
        'الجزء الثاني عشر',
        'الجزء الثالث عشر',
        'الجزء الرابع عشر',
      ],
      joinDate: DateTime.now().subtract(const Duration(days: 365)),
      isActive: true,
      profileImage: null,
      averageRating: 9.2,
      totalSessions: 120,
      notes: 'طالب متقدم ومتميز',
    ),
  ];

  List<Evaluation> get _filteredEvaluations {
    List<Evaluation> filtered = _evaluations;

    // Filter by student
    if (_selectedStudent != 'الكل') {
      filtered = filtered
          .where((evaluation) => evaluation.studentName == _selectedStudent)
          .toList();
    }

    // Filter by performance level
    if (_selectedFilter != 'الكل') {
      filtered = filtered.where((evaluation) {
        final avgScore = evaluation.averageScore;
        switch (_selectedFilter) {
          case 'ممتاز':
            return avgScore >= 8.5;
          case 'جيد جداً':
            return avgScore >= 7.0 && avgScore < 8.5;
          case 'جيد':
            return avgScore >= 5.5 && avgScore < 7.0;
          case 'مقبول':
            return avgScore >= 4.0 && avgScore < 5.5;
          case 'يحتاج تحسين':
            return avgScore < 4.0;
          default:
            return true;
        }
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b.evaluationDate.compareTo(a.evaluationDate));

    return filtered;
  }

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
