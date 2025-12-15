import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';

class AnimatedSearchField extends StatelessWidget {
  const AnimatedSearchField({
    super.key,
    required this.controller,
    required this.isVisible,
    this.onChanged,
  });
  final TextEditingController controller;
  final bool isVisible;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: Offset(0, isVisible ? 0 : -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1 : 0,
        child: isVisible
            ? Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray6),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixIcon: controller.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, size: 20.sp),
                                  onPressed: () {
                                    controller.clear();
                                    onChanged?.call('');
                                  },
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                  30.height,
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
