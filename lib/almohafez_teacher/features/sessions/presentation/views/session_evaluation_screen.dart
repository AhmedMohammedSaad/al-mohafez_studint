import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../data/models/session_model.dart';
import '../../data/models/session_evaluation_model.dart';
import '../../data/repositories/session_evaluations_repo.dart';
import '../cubit/session_evaluation_cubit.dart';
import '../cubit/session_evaluation_state.dart';

class SessionEvaluationScreen extends StatelessWidget {
  final Session session;

  const SessionEvaluationScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionEvaluationCubit(
        SessionEvaluationsRepo(Supabase.instance.client),
      ),
      child: _SessionEvaluationContent(session: session),
    );
  }
}

class _SessionEvaluationContent extends StatefulWidget {
  final Session session;

  const _SessionEvaluationContent({required this.session});

  @override
  State<_SessionEvaluationContent> createState() =>
      _SessionEvaluationContentState();
}

class _SessionEvaluationContentState extends State<_SessionEvaluationContent> {
  int _memorizationScore = 0;
  int _tajweedScore = 0;
  int _overallScore = 0;
  final _notesController = TextEditingController();
  final _strengthsController = TextEditingController();
  final _improvementsController = TextEditingController();
  final _nextGoalsController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _strengthsController.dispose();
    _improvementsController.dispose();
    _nextGoalsController.dispose();
    super.dispose();
  }

  void _populateFromEvaluation(SessionEvaluation evaluation) {
    setState(() {
      _memorizationScore = evaluation.memorizationScore ?? 0;
      _tajweedScore = evaluation.tajweedScore ?? 0;
      _overallScore = evaluation.overallScore ?? 0;
      _notesController.text = evaluation.notes ?? '';
      _strengthsController.text = evaluation.strengths ?? '';
      _improvementsController.text = evaluation.improvements ?? '';
      _nextGoalsController.text = evaluation.nextGoals ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlueViolet,
        elevation: 0,
        title: Text(
          'تقييم الجلسة',
          style: AppTextStyle.textStyle20.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<SessionEvaluationCubit, SessionEvaluationState>(
        listener: (context, state) {
          if (state is SessionEvaluationLoaded && state.evaluation != null) {
            _populateFromEvaluation(state.evaluation!);
          }
          if (state is SessionEvaluationSaved) {
            Fluttertoast.showToast(
              msg: 'تم حفظ التقييم بنجاح',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context, true);
          }
          if (state is SessionEvaluationError) {
            Fluttertoast.showToast(
              msg: 'حدث خطأ: ${state.message}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        builder: (context, state) {
          if (state is SessionEvaluationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session info header
                _buildSessionHeader(),
                SizedBox(height: 24.h),

                // Rating sections
                _buildRatingSection('درجة الحفظ', _memorizationScore, (val) {
                  setState(() => _memorizationScore = val);
                }),
                SizedBox(height: 16.h),

                _buildRatingSection('درجة التجويد', _tajweedScore, (val) {
                  setState(() => _tajweedScore = val);
                }),
                SizedBox(height: 16.h),

                _buildRatingSection('الأداء العام', _overallScore, (val) {
                  setState(() => _overallScore = val);
                }),
                SizedBox(height: 24.h),

                // Notes section
                _buildTextSection('ملاحظات عامة', _notesController, 3),
                SizedBox(height: 16.h),

                _buildTextSection('نقاط القوة', _strengthsController, 2),
                SizedBox(height: 16.h),

                _buildTextSection('نقاط التحسين', _improvementsController, 2),
                SizedBox(height: 16.h),

                _buildTextSection(
                  'أهداف الجلسة القادمة',
                  _nextGoalsController,
                  2,
                ),
                SizedBox(height: 32.h),

                // Save button
                _buildSaveButton(state),
                SizedBox(height: 60.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlueViolet, const Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  widget.session.studentName.isNotEmpty
                      ? widget.session.studentName[0]
                      : 'ط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.session.studentName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.session.topic ?? 'جلسة تحفيظ',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withValues(alpha: 0.8),
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                DateFormat(
                  'EEEE, d MMMM yyyy',
                  'ar',
                ).format(widget.session.scheduledDate),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(
    String title,
    int currentValue,
    Function(int) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.textStyle16Bold.copyWith(
              color: AppColors.primaryBlueViolet,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final value = index + 1;
              return GestureDetector(
                onTap: () => onChanged(value),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Icon(
                    value <= currentValue ? Icons.star : Icons.star_border,
                    size: 36.sp,
                    color: value <= currentValue
                        ? Colors.amber
                        : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
          if (currentValue > 0) ...[
            SizedBox(height: 8.h),
            Center(
              child: Text(
                _getRatingText(currentValue),
                style: TextStyle(
                  color: _getRatingColor(currentValue),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextSection(
    String title,
    TextEditingController controller,
    int maxLines,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.textStyle16Bold.copyWith(
            color: AppColors.primaryBlueViolet,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'أدخل $title...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryBlueViolet),
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(SessionEvaluationState state) {
    final isSaving = state is SessionEvaluationSaving;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : _saveEvaluation,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueViolet,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: isSaving
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'حفظ التقييم',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _saveEvaluation() {
    final evaluation = SessionEvaluation(
      id: '',
      sessionId: widget.session.id,
      studentId: widget.session.studentId,
      studentName: widget.session.studentName,
      teacherId: Supabase.instance.client.auth.currentUser!.id,
      memorizationScore: _memorizationScore > 0 ? _memorizationScore : null,
      tajweedScore: _tajweedScore > 0 ? _tajweedScore : null,
      overallScore: _overallScore > 0 ? _overallScore : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      strengths: _strengthsController.text.trim().isNotEmpty
          ? _strengthsController.text.trim()
          : null,
      improvements: _improvementsController.text.trim().isNotEmpty
          ? _improvementsController.text.trim()
          : null,
      nextGoals: _nextGoalsController.text.trim().isNotEmpty
          ? _nextGoalsController.text.trim()
          : null,
      createdAt: DateTime.now(),
    );

    context.read<SessionEvaluationCubit>().saveEvaluation(evaluation);
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'ضعيف';
      case 2:
        return 'مقبول';
      case 3:
        return 'جيد';
      case 4:
        return 'جيد جداً';
      case 5:
        return 'ممتاز';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.orange;
    return Colors.red;
  }
}
