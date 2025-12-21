import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/student_model.dart';
import '../cubit/teacher_students_cubit.dart';
import '../cubit/teacher_students_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/error_widget.dart';
import '../widgets/student_card_widget.dart';
import '../widgets/students_search_widget.dart';
import 'student_details_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String searchQuery = '';
  String selectedLevel = 'الكل';
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    context.read<TeacherStudentsCubit>().loadStudents();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _navigateToStudentDetails(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsScreen(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('إدارة الطلاب', style: AppTextStyle.font20DarkBlueBold),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            icon: Icon(
              isGridView ? Icons.list : Icons.grid_view,
              color: AppColors.primaryBlueViolet,
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث والفلترة
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                StudentsSearchWidget(onSearchChanged: _onSearchChanged),
                SizedBox(height: 12.h),
              ],
            ),
          ),

          // قائمة الطلاب
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<TeacherStudentsCubit>().loadStudents();
              },
              child: BlocBuilder<TeacherStudentsCubit, TeacherStudentsState>(
                builder: (context, state) {
                  if (state is TeacherStudentsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TeacherStudentsError) {
                    if (state.message.contains('User not logged in')) {
                      return const SizedBox.shrink();
                    }
                    return AppErrorWidget(
                      message: state.message,
                      onRefresh: () {
                        context.read<TeacherStudentsCubit>().loadStudents();
                      },
                    );
                  } else if (state is TeacherStudentsLoaded) {
                    if (state.students.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 100.h),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 64.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'لا يوجد طلاب حالياً',
                                  style: AppTextStyle.font16DarkBlueBold,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'سيبدأ الطلاب بالظهور هنا عند بدء الجلسات',
                                  style: AppTextStyle.font14GreyRegular,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    final displayStudents = state.students.where((student) {
                      final name = '${student.firstName} ${student.lastName}';
                      final matchesSearch =
                          name.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ) ||
                          student.currentPart.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          );
                      return matchesSearch;
                    }).toList();

                    if (displayStudents.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 100.h),
                          _buildEmptyState(),
                        ],
                      );
                    }

                    return isGridView
                        ? _buildGridView(displayStudents)
                        : _buildListView(displayStudents);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          65.height,
        ],
      ),
    );
  }

  Widget _buildGridView(List<Student> students) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return StudentCardWidget(
          student: students[index],
          onTap: () => _navigateToStudentDetails(students[index]),
          isGridView: true,
        );
      },
    );
  }

  Widget _buildListView(List<Student> students) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: StudentCardWidget(
            student: students[index],
            onTap: () => _navigateToStudentDetails(students[index]),
            isGridView: false,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text('لا توجد نتائج', style: AppTextStyle.font12GreyMedium),
          SizedBox(height: 8.h),
          Text('جرب تغيير معايير البحث', style: AppTextStyle.font14GreyRegular),
        ],
      ),
    );
  }
}
