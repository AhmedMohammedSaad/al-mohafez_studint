import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/student_model.dart';
import '../../../sessions/data/models/session_evaluation_model.dart';
import '../cubit/student_details_cubit.dart';
import '../cubit/student_details_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/student_bookings_list.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<StudentDetailsCubit>().loadStudentDetails(widget.student.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<StudentDetailsCubit, StudentDetailsState>(
        builder: (context, state) {
          if (state is StudentDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentDetailsError) {
            return Center(child: Text(state.message));
          }

          Student displayStudent = widget.student;
          List<Map<String, dynamic>> bookings = [];
          List<SessionEvaluation> evaluations = [];
          double averageRating = 0.0;

          if (state is StudentDetailsLoaded) {
            displayStudent = widget.student.copyWith(
              totalSessions: state.stats['totalSessions'] as int,
              averageRating: state.averageRating,
            );
            bookings = state.bookings;
            evaluations = state.evaluations;
            averageRating = state.averageRating;
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220.h,
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
                          CircleAvatar(
                            radius: 40.r,
                            backgroundColor: Colors.white,
                            backgroundImage: displayStudent.profileImage != null
                                ? NetworkImage(displayStudent.profileImage!)
                                : null,
                            child: displayStudent.profileImage == null
                                ? Icon(
                                    Icons.person,
                                    size: 40.sp,
                                    color: AppColors.primaryBlueViolet,
                                  )
                                : null,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Average rating badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      averageRating.toStringAsFixed(1),
                                      style: AppTextStyle.font12WhiteMedium,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "${displayStudent.firstName} ${displayStudent.lastName}",
                                style: AppTextStyle.font20Blackw700.copyWith(
                                  color: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Cairo',
                                  height: 1.2,
                                  letterSpacing: 0.5,
                                  wordSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //     horizontal: 12.w,
                              //     vertical: 4.h,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white.withValues(alpha: 0.2),
                              //     borderRadius: BorderRadius.circular(12.r),
                              //   ),
                              //   child: Text(
                              //     displayStudent.level,
                              //     style: AppTextStyle.font12WhiteMedium,
                              //   ),
                              // ),
                              // SizedBox(width: 8.w),
                            ],
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
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    StudentInfoCard(student: displayStudent),

                    TabBar(
                      dividerColor: Colors.transparent,
                      // labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primaryBlueViolet,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.primaryBlueViolet,
                      labelStyle: AppTextStyle.font16white700,
                      unselectedLabelStyle: AppTextStyle.font14DarkBlueMedium,
                      isScrollable: true,
                      tabs: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: const Tab(text: 'التقييمات'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: const Tab(text: 'الجلسات'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: const Tab(text: 'الملاحظات'),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 500.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // تبويب التقييمات
                          _buildEvaluationsTab(evaluations),

                          // تبويب الجلسات
                          StudentBookingsList(bookings: bookings),

                          // تبويب الملاحظات
                          _buildNotesTab(evaluations),
                        ],
                      ),
                    ),
                    65.height,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEvaluationsTab(List<SessionEvaluation> evaluations) {
    if (evaluations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_outline_rounded,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text('لا توجد تقييمات بعد', style: AppTextStyle.font16DarkBlueBold),
            SizedBox(height: 8.h),
            Text(
              'سيظهر هنا تقييمات الطالب بعد كل جلسة',
              style: AppTextStyle.font14GreyRegular,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: evaluations.length,
      itemBuilder: (context, index) {
        final eval = evaluations[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 221, 220, 220),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and average
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('d MMMM yyyy', 'ar').format(eval.createdAt),
                    style: AppTextStyle.font12GreyMedium,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getRatingColor(
                        eval.averageScore,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 20.sp,
                          color: _getRatingColor(eval.averageScore),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          eval.averageScore.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: _getRatingColor(eval.averageScore),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Scores row
              Row(
                children: [
                  _buildScoreChip('الحفظ', eval.memorizationScore),
                  SizedBox(width: 8.w),
                  _buildScoreChip('التجويد', eval.tajweedScore),
                  SizedBox(width: 8.w),
                  _buildScoreChip('الأداء', eval.overallScore),
                ],
              ),

              if (eval.notes != null && eval.notes!.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    eval.notes!,
                    style: AppTextStyle.font14GreyRegular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreChip(String label, int? score) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyle.font12GreyMedium.copyWith(
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            score?.toString() ?? '-',
            style: AppTextStyle.font12GreyMedium.copyWith(
              color: AppColors.primaryBlueViolet,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return Colors.green;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }

  Widget _buildNotesTab(List<SessionEvaluation> evaluations) {
    // Get all evaluations with notes
    final evaluationsWithNotes = evaluations
        .where((e) => e.notes != null && e.notes!.isNotEmpty)
        .toList();

    if (evaluationsWithNotes.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ملاحظات الجلسات', style: AppTextStyle.font16DarkBlueBold),
            SizedBox(height: 24.h),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد ملاحظات بعد',
                    style: AppTextStyle.font14DarkBlueMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'سيظهر هنا ملاحظات الجلسات عند إضافتها',
                    style: AppTextStyle.font12GreyRegular,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملاحظات الجلسات (${evaluationsWithNotes.length})',
            style: AppTextStyle.font16DarkBlueBold,
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              itemCount: evaluationsWithNotes.length,
              itemBuilder: (context, index) {
                final eval = evaluationsWithNotes[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayConstant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.lightGrayConstant,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'd MMMM yyyy',
                              'ar',
                            ).format(eval.createdAt),
                            style: AppTextStyle.font12GreyRegular,
                          ),
                          Icon(
                            Icons.note,
                            size: 16.sp,
                            color: AppColors.primaryBlueViolet,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Note content
                      Text(
                        eval.notes!,
                        style: AppTextStyle.font14DarkBlueRegular,
                      ),
                      // Show strengths if available
                      if (eval.strengths != null &&
                          eval.strengths!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              size: 14.sp,
                              color: Colors.green,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                'القوة: ${eval.strengths}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Show improvements if available
                      if (eval.improvements != null &&
                          eval.improvements!.isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 14.sp,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                'للتحسين: ${eval.improvements}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
