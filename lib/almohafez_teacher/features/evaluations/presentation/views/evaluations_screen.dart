import 'package:almohafez/almohafez_teacher/features/evaluations/presentation/widgets/evaluations_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/teacher_ratings_repo.dart';
import '../cubit/teacher_ratings_cubit.dart';
import '../cubit/teacher_ratings_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class EvaluationsScreen extends StatelessWidget {
  const EvaluationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TeacherRatingsCubit(TeacherRatingsRepo(Supabase.instance.client))
            ..loadRatings(),
      child: const _EvaluationsContent(),
    );
  }
}

class _EvaluationsContent extends StatelessWidget {
  const _EvaluationsContent();

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
      ),
      body: BlocBuilder<TeacherRatingsCubit, TeacherRatingsState>(
        builder: (context, state) {
          if (state is TeacherRatingsLoading) {
            return _buildLoadingState();
          }

          if (state is TeacherRatingsError) {
            return _buildErrorState(context, state.message);
          }

          if (state is TeacherRatingsLoaded) {
            if (state.ratings.isEmpty) {
              return _buildEmptyState();
            }
            // Convert TeacherRating to StudentEvaluation for the widget
            final evaluations = state.ratings
                .map(
                  (r) => StudentEvaluation(
                    studentName: r.studentName,
                    rating: r.rating,
                    comment: r.comment ?? '',
                    evaluationDate: r.createdAt,
                  ),
                )
                .toList();

            return Column(
              children: [
                SizedBox(height: 16.h),
                EvaluationsStatsWidget(studentEvaluations: evaluations),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'حدث خطأ في تحميل التقييمات',
            style: AppTextStyle.textStyle18.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              context.read<TeacherRatingsCubit>().loadRatings();
            },
            icon: const Icon(Icons.refresh),
            label: Text('retry'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlueViolet,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 80.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'لا توجد تقييمات بعد',
            style: AppTextStyle.textStyle18.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'سيظهر هنا تقييمات الطلاب للشيخ',
            style: AppTextStyle.textStyle14.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
