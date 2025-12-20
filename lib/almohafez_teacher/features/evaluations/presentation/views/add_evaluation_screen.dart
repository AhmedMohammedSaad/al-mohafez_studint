import 'package:almohafez/almohafez_teacher/features/evaluations/presentation/widgets/evaluation_notes_widget.dart';
import 'package:almohafez/almohafez_teacher/features/evaluations/presentation/widgets/evaluation_score_widget.dart';
import 'package:almohafez/almohafez_teacher/features/evaluations/presentation/widgets/evaluation_topics_widget.dart';
import 'package:almohafez/almohafez_teacher/features/students/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../sessions/data/models/session_model.dart';
import '../../data/models/evaluation_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class AddEvaluationScreen extends StatefulWidget {
  final Session session;
  final Student student;

  const AddEvaluationScreen({
    super.key,
    required this.session,
    required this.student,
  });

  @override
  State<AddEvaluationScreen> createState() => _AddEvaluationScreenState();
}

class _AddEvaluationScreenState extends State<AddEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _strengthsController = TextEditingController();
  final _improvementsController = TextEditingController();
  final _nextGoalsController = TextEditingController();
  final _topicsController = TextEditingController();

  double _memorizationScore = 5.0;
  double _tajweedScore = 5.0;
  double _overallScore = 5.0;
  bool _isCompleted = false;

  @override
  void dispose() {
    _notesController.dispose();
    _strengthsController.dispose();
    _improvementsController.dispose();
    _nextGoalsController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'تقييم الطالب',
          style: AppTextStyle.textStyle20Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20.sp,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student and Session Info
              _buildSessionInfoCard(),

              SizedBox(height: 20.h),

              // Evaluation Scores
              _buildScoresSection(),

              SizedBox(height: 20.h),

              // Topics Covered
              EvaluationTopicsWidget(
                controller: _topicsController,
                onChanged: (value) {
                  // Handle topics change
                },
              ),

              SizedBox(height: 20.h),

              // Notes and Feedback
              EvaluationNotesWidget(
                notesController: _notesController,
                strengthsController: _strengthsController,
                improvementsController: _improvementsController,
                nextGoalsController: _nextGoalsController,
              ),

              SizedBox(height: 20.h),

              // Completion Status
              _buildCompletionSection(),

              SizedBox(height: 30.h),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات الجلسة',
            style: AppTextStyle.textStyle12Medium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الطالب',
                      style: AppTextStyle.textStyle12Medium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      widget.student.firstName,
                      style: AppTextStyle.textStyle14Bold.copyWith(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التاريخ',
                      style: AppTextStyle.textStyle12Medium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'dd/MM/yyyy',
                        'ar',
                      ).format(widget.session.scheduledDate),
                      style: AppTextStyle.textStyle14Bold.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (widget.session.topic != null) ...[
            Text(
              'الموضوع',
              style: AppTextStyle.textStyle12Bold.copyWith(
                color: AppColors.grey,
              ),
            ),
            Text(
              widget.session.topic!,
              style: AppTextStyle.textStyle14Bold.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoresSection() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التقييم',
            style: AppTextStyle.textStyle18Bold.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueViolet,
            ),
          ),
          SizedBox(height: 16.h),
          EvaluationScoreWidget(
            title: 'الحفظ',
            score: _memorizationScore,
            onChanged: (value) {
              setState(() {
                _memorizationScore = value;
              });
            },
            icon: Icons.menu_book,
            color: AppColors.blue,
          ),
          SizedBox(height: 16.h),
          EvaluationScoreWidget(
            title: 'التجويد',
            score: _tajweedScore,
            onChanged: (value) {
              setState(() {
                _tajweedScore = value;
              });
            },
            icon: Icons.record_voice_over,
            color: AppColors.success,
          ),
          SizedBox(height: 16.h),
          EvaluationScoreWidget(
            title: 'الأداء العام',
            score: _overallScore,
            onChanged: (value) {
              setState(() {
                _overallScore = value;
              });
            },
            icon: Icons.star,
            color: AppColors.orange,
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueViolet.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calculate,
                  color: AppColors.primaryBlueViolet,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'المتوسط العام: ',
                  style: AppTextStyle.textStyle14Bold.copyWith(
                    color: AppColors.primaryBlueViolet,
                  ),
                ),
                Text(
                  '${((_memorizationScore + _tajweedScore + _overallScore) / 3).toStringAsFixed(1)}/10',
                  style: AppTextStyle.textStyle16Bold.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlueViolet,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionSection() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حالة الإنجاز',
            style: AppTextStyle.textStyle18Bold.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueViolet,
            ),
          ),
          SizedBox(height: 16.h),
          SwitchListTile(
            title: Text(
              'تم إنجاز الأهداف المطلوبة',
              style: AppTextStyle.textStyle16Bold,
            ),
            subtitle: Text(
              _isCompleted
                  ? 'الطالب أنجز جميع الأهداف المحددة للجلسة'
                  : 'الطالب لم ينجز جميع الأهداف المحددة',
              style: AppTextStyle.textStyle14Bold.copyWith(
                color: AppColors.grey,
              ),
            ),
            value: _isCompleted,
            onChanged: (value) {
              setState(() {
                _isCompleted = value;
              });
            },
            activeColor: AppColors.greenColor,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _saveEvaluation,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueViolet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'حفظ التقييم',
          style: AppTextStyle.textStyle16Bold.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _saveEvaluation() {
    if (_formKey.currentState!.validate()) {
      // Create evaluation object
      final evaluation = Evaluation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sessionId: widget.session.id,
        studentId: widget.student.id,
        studentName: widget.student.firstName,
        evaluationDate: DateTime.now(),
        memorizationScore: _memorizationScore,
        tajweedScore: _tajweedScore,

        notes: _notesController.text.trim(),
        strengths: _strengthsController.text.trim(),
        improvements: _improvementsController.text.trim(),
        nextSessionGoals: _nextGoalsController.text.trim(),
        topics: [_topicsController.text.trim()],
        isCompleted: _isCompleted,
        overallPerformance: _overallScore,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم حفظ التقييم بنجاح',
            style: AppTextStyle.textStyle14Bold.copyWith(
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.greenColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );

      // Return to previous screen
      Navigator.pop(context, evaluation);
    }
  }
}
