import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/repos/teachers_repo.dart';
import '../../logic/teachers_cubit.dart';
import '../../logic/teachers_state.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/presentation/view/widgets/error_widget.dart';
import '../widgets/tutor_card.dart';
import 'tutor_profile_screen.dart';

class TutorsListScreen extends StatelessWidget {
  final String gender;

  const TutorsListScreen({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TeachersCubit(TeachersRepo())..fetchTeachers(gender: gender),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'teachers'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A1D64),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color(0xFF0A1D64),
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<TeachersCubit, TeachersState>(
          builder: (context, state) {
            if (state is TeachersLoading) {
              return _buildLoadingWidget();
            } else if (state is TeachersError) {
              return AppErrorWidget(
                message: state.message,
                onRefresh: () =>
                    context.read<TeachersCubit>().fetchTeachers(gender: gender),
              );
            } else if (state is TeachersLoaded) {
              if (state.teachers.isEmpty) {
                return _buildEmptyWidget();
              }
              return _buildTutorsList(context, state.teachers);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      children: [
        // Hidden shimmer for count header to maintain layout or just space
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 40.h,
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80.sp, color: const Color(0xFF5B6C9F)),
            SizedBox(height: 20.h),
            Text(
              'teachers_empty_title'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0A1D64),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'teachers_empty_subtitle'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: const Color(0xFF5B6C9F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorsList(BuildContext context, List<dynamic> tutors) {
    return Column(
      children: [
        // عداد المحفظين
        // Container(
        //   width: double.infinity,
        //   margin: EdgeInsets.all(16.w),
        //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF00E0FF).withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(12.r),
        //   ),
        //   child: Text(
        //     'teachers_found_count'.tr(
        //       namedArgs: {'count': tutors.length.toString()},
        //     ),
        //     style: TextStyle(
        //       fontFamily: 'Cairo',
        //       fontSize: 14.sp,
        //       fontWeight: FontWeight.w600,
        //       color: const Color(0xFF0A1D64),
        //     ),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        // قائمة المحفظين
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: tutors.length,
            itemBuilder: (context, index) {
              final tutor = tutors[index];
              return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: TutorCard(
                      tutor: tutor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TutorProfileScreen(tutor: tutor),
                          ),
                        );
                      },
                    ),
                  )
                  .animate(delay: (index > 5 ? 0 : index * 100).ms)
                  .fade(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad)
                  .then()
                  .shimmer(duration: 1200.ms);
            },
          ),
        ),
        SizedBox(height: 70.h),
      ],
    );
  }
}
