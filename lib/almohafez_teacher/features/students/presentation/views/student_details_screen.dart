import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/models/student_model.dart';
import '../../../evaluations/data/models/evaluation_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/student_progress_chart.dart';
import '../widgets/student_evaluations_list.dart';
import '../widgets/student_info_card.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Evaluation> evaluations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvaluations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadEvaluations() {
    // بيانات تجريبية للتقييمات
    evaluations = [
      Evaluation(
        id: '1',
        sessionId: 'session_1',
        studentId: widget.student.id,
        studentName: widget.student.name,
        evaluationDate: DateTime.now().subtract(const Duration(days: 1)),
        memorizationScore: 4.5,
        tajweedScore: 4.0,
        overallPerformance: 4.2,
        notes: 'أداء ممتاز في الحفظ، يحتاج تحسين في التجويد',
        strengths: 'حفظ قوي',
        improvements: 'سرعة القراءة',
        nextSessionGoals: 'مراجعة أحكام النون الساكنة',
        topics: ['سورة البقرة - الآيات 1-10'],
      ),
      Evaluation(
        id: '2',
        sessionId: 'session_2',
        studentId: widget.student.id,
        studentName: widget.student.name,
        evaluationDate: DateTime.now().subtract(const Duration(days: 3)),
        memorizationScore: 4.0,
        tajweedScore: 4.5,
        overallPerformance: 4.3,
        notes: 'تحسن ملحوظ في التجويد',
        strengths: 'انتباه للتفاصيل',
        improvements: 'سرعة الحفظ',
        nextSessionGoals: 'حفظ الآيات الجديدة',
        topics: ['سورة البقرة - الآيات 11-20'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar مخصص
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryBlueViolet,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlueViolet,
                      AppColors.primaryColor2,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      // صورة الطالب
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.student.profileImage != null
                            ? NetworkImage(widget.student.profileImage!)
                            : null,
                        child: widget.student.profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 40.sp,
                                color: AppColors.primaryBlueViolet,
                              )
                            : null,
                      ),
                      SizedBox(height: 12.h),
                      // اسم الطالب
                      Text(
                        widget.student.name,
                        style: AppTextStyle.font20Blackw700,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      // المستوى
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.student.level,
                          style: AppTextStyle.font12WhiteMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {
            //       // إرسال رسالة للطالب
            //     },
            //     icon: const Icon(Icons.message, color: Colors.white),
            //   ),
            //   IconButton(
            //     onPressed: () {
            //       // تعديل بيانات الطالب
            //     },
            //     icon: const Icon(Icons.edit, color: Colors.white),
            //   ),
            // ],
          ),

          // محتوى الشاشة
          SliverToBoxAdapter(
            child: Column(
              children: [
                // معلومات سريعة
                StudentInfoCard(student: widget.student),

                // التبويبات
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayConstant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primaryBlueViolet,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.primaryBlueViolet,
                    labelStyle: AppTextStyle.font16white700,
                    unselectedLabelStyle: AppTextStyle.font14DarkBlueMedium,
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Tab(text: 'التقدم'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Tab(text: 'التقييمات'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Tab(text: 'الملاحظات'),
                      ),
                    ],
                  ),
                ),

                // محتوى التبويبات
                SizedBox(
                  height: 400.h,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // تبويب التقدم
                      StudentProgressChart(student: widget.student),

                      // تبويب التقييمات
                      StudentEvaluationsList(evaluations: evaluations),

                      // تبويب الملاحظات
                      _buildNotesTab(),
                    ],
                  ),
                ),
                65.height,
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // بدء جلسة جديدة
      //   },
      //   backgroundColor: AppColors.primaryColor2,
      //   icon: const Icon(Icons.play_arrow, color: Colors.white),
      //   label: Text('بدء جلسة', style: AppTextStyle.font12WhiteMedium),
      // ),
    );
  }

  Widget _buildNotesTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ملاحظات الشيخ', style: AppTextStyle.font16DarkBlueBold),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.lightGrayConstant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.lightGrayConstant, width: 1),
            ),
            child: Text(
              widget.student.notes ?? 'لا توجد ملاحظات',
              style: AppTextStyle.font14DarkBlueRegular,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // تعديل الملاحظات
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlueViolet,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'تعديل الملاحظات',
                style: AppTextStyle.font16white700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
