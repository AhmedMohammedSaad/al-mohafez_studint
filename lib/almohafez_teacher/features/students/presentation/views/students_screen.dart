import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/models/student_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../widgets/student_card_widget.dart';
import '../widgets/students_search_widget.dart';
import 'student_details_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> students = [];
  List<Student> filteredStudents = [];
  String searchQuery = '';
  String selectedLevel = 'الكل';
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    // بيانات تجريبية للطلاب
    students = [
      Student(
        id: '1',
        name: 'أحمد محمد علي',
        email: 'ahmed@example.com',
        phone: '+966501234567',
        profileImage: null,
        joinDate: DateTime.now().subtract(const Duration(days: 30)),
        level: 'متوسط',
        totalSessions: 25,
        averageRating: 4.5,
        currentPart: 'الجزء الخامس',
        completedParts: [
          'الجزء الأول',
          'الجزء الثاني',
          'الجزء الثالث',
          'الجزء الرابع',
        ],
        notes: 'طالب مجتهد ومتميز في الحفظ',
      ),
      Student(
        id: '2',
        name: 'فاطمة عبدالله',
        email: 'fatima@example.com',
        phone: '+966507654321',
        profileImage: null,
        joinDate: DateTime.now().subtract(const Duration(days: 60)),
        level: 'متقدم',
        totalSessions: 45,
        averageRating: 4.8,
        currentPart: 'الجزء العاشر',
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
        ],
        notes: 'طالبة متفوقة جداً',
      ),
      Student(
        id: '3',
        name: 'محمد عبدالرحمن',
        email: 'mohammed@example.com',
        phone: '+966509876543',
        profileImage: null,
        joinDate: DateTime.now().subtract(const Duration(days: 15)),
        level: 'مبتدئ',
        totalSessions: 8,
        averageRating: 3.5,
        currentPart: 'الجزء الثاني',
        completedParts: ['الجزء الأول'],
        notes: 'يحتاج المزيد من التشجيع',
      ),
      Student(
        id: '4',
        name: 'عائشة سالم',
        email: 'aisha@example.com',
        phone: '+966502468135',
        profileImage: null,
        joinDate: DateTime.now().subtract(const Duration(days: 90)),
        level: 'متقدم',
        totalSessions: 60,
        averageRating: 4.7,
        currentPart: 'الجزء الخامس عشر',
        completedParts: List.generate(
          14,
          (index) => 'الجزء ${_getArabicNumber(index + 1)}',
        ),
        notes: 'طالبة مميزة في التجويد',
      ),
      Student(
        id: '5',
        name: 'عائشة سالم',
        email: 'aisha@example.com',
        phone: '+966502468135',
        profileImage: null,
        joinDate: DateTime.now().subtract(const Duration(days: 90)),
        level: 'متقدم',
        totalSessions: 60,
        averageRating: 4.7,
        currentPart: 'الجزء الخامس عشر',
        completedParts: List.generate(
          14,
          (index) => 'الجزء ${_getArabicNumber(index + 1)}',
        ),
        notes: 'طالبة مميزة في التجويد',
      ),
      Student(
        id: '6',
        name: 'عائشة سالم',
        email: 'aisha@example.com',
        phone: '+966502468135',
        profileImage: null,
        joinDate: DateTime.now().subtract(const Duration(days: 90)),
        level: 'متقدم',
        totalSessions: 60,
        averageRating: 4.7,
        currentPart: 'الجزء الخامس عشر',
        completedParts: List.generate(
          14,
          (index) => 'الجزء ${_getArabicNumber(index + 1)}',
        ),
        notes: 'طالبة مميزة في التجويد',
      ),
    ];
    filteredStudents = students;
  }

  String _getArabicNumber(int number) {
    const arabicNumbers = [
      'الأول',
      'الثاني',
      'الثالث',
      'الرابع',
      'الخامس',
      'السادس',
      'السابع',
      'الثامن',
      'التاسع',
      'العاشر',
      'الحادي عشر',
      'الثاني عشر',
      'الثالث عشر',
      'الرابع عشر',
      'الخامس عشر',
      'السادس عشر',
      'السابع عشر',
      'الثامن عشر',
      'التاسع عشر',
      'العشرون',
      'الحادي والعشرون',
      'الثاني والعشرون',
      'الثالث والعشرون',
      'الرابع والعشرون',
      'الخامس والعشرون',
      'السادس والعشرون',
      'السابع والعشرون',
      'الثامن والعشرون',
      'التاسع والعشرون',
      'الثلاثون',
    ];
    return number <= arabicNumbers.length
        ? arabicNumbers[number - 1]
        : number.toString();
  }

  void _filterStudents() {
    setState(() {
      filteredStudents = students.where((student) {
        final matchesSearch =
            student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            student.currentPart.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
        final matchesLevel =
            selectedLevel == 'الكل' || student.level == selectedLevel;
        return matchesSearch && matchesLevel;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    searchQuery = query;
    _filterStudents();
  }

  // void _onLevelChanged(String level) {
  //   selectedLevel = level;
  //   _filterStudents();
  // }

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
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                StudentsSearchWidget(onSearchChanged: _onSearchChanged),
                SizedBox(height: 12.h),
                // StudentsFilterWidget(
                // selectedLevel: selectedLevel,
                // onLevelChanged: _onLevelChanged,
                // ),
              ],
            ),
          ),

          // إحصائيات سريعة
          // Container(
          // margin: EdgeInsets.all(16.w),
          // padding: EdgeInsets.all(16.w),
          // decoration: BoxDecoration(
          // gradient: LinearGradient(
          // colors: [AppColors.primaryBlueViolet, AppColors.primaryColor2],
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          // ),
          // borderRadius: BorderRadius.circular(12.r),
          // ),
          // child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // children: [
          // _buildStatItem(
          // 'إجمالي الطلاب',
          // '${students.length}',
          // Icons.people,
          // ),
          // _buildStatItem(
          // 'النشطين',
          // '${students.where((s) => s.isActive).length}',
          // Icons.check_circle,
          // ),
          // _buildStatItem('متوسط التقييم', '4.6', Icons.star),
          // ],
          // ),
          // ),

          // قائمة الطلاب
          Expanded(
            child: filteredStudents.isEmpty
                ? _buildEmptyState()
                : isGridView
                ? _buildGridView()
                : _buildListView(),
          ),
          65.height,
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        return StudentCardWidget(
          student: filteredStudents[index],
          onTap: () => _navigateToStudentDetails(filteredStudents[index]),
          isGridView: true,
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: StudentCardWidget(
            student: filteredStudents[index],
            onTap: () => _navigateToStudentDetails(filteredStudents[index]),
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
