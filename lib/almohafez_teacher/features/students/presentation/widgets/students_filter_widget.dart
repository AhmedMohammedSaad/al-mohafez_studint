import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class StudentsFilterWidget extends StatelessWidget {
  final String selectedLevel;
  final Function(String) onLevelChanged;

  const StudentsFilterWidget({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final levels = ['الكل', 'مبتدئ', 'متوسط', 'متقدم'];

    return Row(
      children: [
        Text('المستوى:', style: AppTextStyle.font14DarkBlueMedium),
        SizedBox(width: 12.w),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: levels.map((level) {
                final isSelected = selectedLevel == level;
                return Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: GestureDetector(
                    onTap: () => onLevelChanged(level),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlueViolet
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlueViolet
                              : AppColors.lightGrayConstant,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        level,
                        style: isSelected
                            ? AppTextStyle.font12WhiteMedium
                            : AppTextStyle.font12GreyMedium,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
