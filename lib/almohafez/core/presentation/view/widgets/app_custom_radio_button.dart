import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioOption<T> extends StatelessWidget {
  const CustomRadioOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    required this.activeColor,
    this.textStyle,
  });
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?> onChanged;
  final Color activeColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          activeColor: activeColor,
          groupValue: groupValue,
          fillColor: WidgetStateProperty.all(activeColor),
          onChanged: onChanged,
        ),
        Text(
          label,
          style: textStyle ??
              TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
        ),
      ],
    );
  }
}
