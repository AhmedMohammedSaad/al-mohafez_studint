import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/student_model.dart';
import '../cubit/student_details_cubit.dart';
import '../cubit/student_details_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/student_progress_chart.dart';
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
          String? latestNote;

          if (state is StudentDetailsLoaded) {
            // Update student stats with real data
            displayStudent = widget.student.copyWith(
              totalSessions: state.stats['totalSessions'] as int,
            );
            bookings = state.bookings;

            // Get latest note from the most recent booking
            if (bookings.isNotEmpty) {
              final latestBookingWithNote = bookings.firstWhere(
                (b) => b['notes'] != null && b['notes'].toString().isNotEmpty,
                orElse: () => {},
              );
              if (latestBookingWithNote.isNotEmpty) {
                latestNote = latestBookingWithNote['notes'];
              }
            }
          }

          return CustomScrollView(
            slivers: [
              // App Bar
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
                          // اسم الطالب
                          Text(
                            displayStudent.firstName,
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
                              displayStudent.level,
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
              ),

              // محتوى الشاشة
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // معلومات سريعة
                    StudentInfoCard(student: displayStudent),

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
                            child: Tab(text: 'الجلسات'),
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
                          StudentProgressChart(student: displayStudent),

                          // تبويب الجلسات (بدلاً من التقييمات)
                          StudentBookingsList(bookings: bookings),

                          // تبويب الملاحظات
                          _buildNotesTab(latestNote),
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

  Widget _buildNotesTab(String? note) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('آخر ملاحظات', style: AppTextStyle.font16DarkBlueBold),
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
              note ?? widget.student.notes ?? 'لا توجد ملاحظات',
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
