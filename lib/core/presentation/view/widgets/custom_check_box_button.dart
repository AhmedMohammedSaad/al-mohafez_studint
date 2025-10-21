import 'package:almohafez/core/theme/app_colors.dart';
import 'package:almohafez/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckboxOption extends StatelessWidget {
  const CustomCheckboxOption({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    required this.activeColor,
    this.textStyle,
  });
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
            side: const BorderSide(color: AppColors.newGray),
          ),
          value: value,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
        Text(
          label,
          style:
              textStyle ??
              AppTextStyle.regular14.copyWith(
                color: AppColors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
