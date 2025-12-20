import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../../students/data/models/student_model.dart';

class EvaluationsFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final String selectedStudent;
  final List<String> filterOptions;
  final List<Student> students;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onStudentChanged;

  const EvaluationsFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedStudent,
    required this.filterOptions,
    required this.students,
    required this.onFilterChanged,
    required this.onStudentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: AppColors.primaryBlueViolet,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'تصفية النتائج',
                style: AppTextStyle.textStyle16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlueViolet,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Performance Level Filter
          Text(
            'مستوى الأداء',
            style: AppTextStyle.textStyle14.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),

          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filterOptions.length,
              itemBuilder: (context, index) {
                final option = filterOptions[index];
                final isSelected = selectedFilter == option;

                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () => onFilterChanged(option),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlueViolet
                            : AppColors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlueViolet
                              : AppColors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (option != 'الكل') ...[
                            Icon(
                              _getFilterIcon(option),
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.grey,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                          ],
                          Text(
                            option,
                            style: AppTextStyle.textStyle12.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16.h),

          // Student Filter
          Text(
            'الطالب',
            style: AppTextStyle.textStyle14.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStudent,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryBlueViolet,
                ),
                style: AppTextStyle.textStyle14.copyWith(
                  color: AppColors.primaryBlueViolet,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: 'الكل',
                    child: Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: AppColors.primaryBlueViolet,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text('جميع الطلاب'),
                      ],
                    ),
                  ),
                  ...students.map((student) {
                    return DropdownMenuItem<String>(
                      value: student.firstName,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12.r,
                            backgroundColor: AppColors.primaryBlueViolet
                                .withOpacity(0.1),
                            child: Text(
                              student.firstName[0],
                              style: AppTextStyle.textStyle12.copyWith(
                                color: AppColors.primaryBlueViolet,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              student.firstName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(
                                student.level,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              _getLevelText(student.level),
                              style: AppTextStyle.textStyle10.copyWith(
                                color: _getLevelColor(student.level),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onStudentChanged(value);
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Active Filters Summary
          if (selectedFilter != 'الكل' || selectedStudent != 'الكل') ...[
            Divider(color: AppColors.grey.withOpacity(0.3)),
            SizedBox(height: 8.h),
            Text(
              'الفلاتر النشطة:',
              style: AppTextStyle.textStyle12.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: [
                if (selectedFilter != 'الكل')
                  _buildActiveFilterChip(
                    'المستوى: $selectedFilter',
                    () => onFilterChanged('الكل'),
                  ),
                if (selectedStudent != 'الكل')
                  _buildActiveFilterChip(
                    'الطالب: $selectedStudent',
                    () => onStudentChanged('الكل'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueViolet.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryBlueViolet.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.textStyle10.copyWith(
              color: AppColors.primaryBlueViolet,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              color: AppColors.primaryBlueViolet,
              size: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'ممتاز':
        return Icons.emoji_events;
      case 'جيد جداً':
        return Icons.thumb_up;
      case 'جيد':
        return Icons.trending_up;
      case 'مقبول':
        return Icons.warning;
      case 'يحتاج تحسين':
        return Icons.trending_down;
      default:
        return Icons.filter_list;
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'مبتدئ':
        return AppColors.green;
      case 'متوسط':
        return AppColors.orange;
      case 'متقدم':
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  String _getLevelText(String level) {
    switch (level) {
      case 'مبتدئ':
        return 'مبتدئ';
      case 'متوسط':
        return 'متوسط';
      case 'متقدم':
        return 'متقدم';
      default:
        return 'غير محدد';
    }
  }
}
