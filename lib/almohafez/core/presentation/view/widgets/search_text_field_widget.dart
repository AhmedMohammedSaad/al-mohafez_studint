import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';

import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SearchWidgetTextField extends StatelessWidget {
  const SearchWidgetTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
    this.prefixIcon,
    this.border,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;
  final String hintText;
  final Widget? prefixIcon;
  final InputBorder? border;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      style: AppTextStyle.font16darkGray400,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.font16darkGray400,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        prefixIcon:
            prefixIcon ??
            const Icon(Icons.search, color: AppColors.grayTextForm),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.grayTextForm),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        focusedBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.0),
            ),
        enabledBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.grayTextForm,
                width: 1.0,
              ),
            ),
        border:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: Colors.black),
            ),
      ),
    );
  }
}
