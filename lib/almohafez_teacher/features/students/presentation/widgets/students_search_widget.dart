import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class StudentsSearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;

  const StudentsSearchWidget({super.key, required this.onSearchChanged});

  @override
  State<StudentsSearchWidget> createState() => _StudentsSearchWidgetState();
}

class _StudentsSearchWidgetState extends State<StudentsSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrayConstant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGrayConstant, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.right,
        style: AppTextStyle.font14DarkBlueRegular,
        decoration: InputDecoration(
          hintText: 'ابحث عن طالب أو جزء...',
          hintStyle: AppTextStyle.font14GreyRegular,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primaryBlueViolet,
            size: 20.sp,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                  },
                  icon: Icon(Icons.clear, color: Colors.grey, size: 20.sp),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          widget.onSearchChanged(value);
        },
      ),
    );
  }
}
