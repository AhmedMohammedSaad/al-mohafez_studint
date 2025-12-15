import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class EvaluationTopicsWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const EvaluationTopicsWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<EvaluationTopicsWidget> createState() => _EvaluationTopicsWidgetState();
}

class _EvaluationTopicsWidgetState extends State<EvaluationTopicsWidget> {
  final List<String> _selectedTopics = [];
  final List<String> _commonTopics = [
    'سورة البقرة',
    'سورة آل عمران',
    'سورة النساء',
    'سورة المائدة',
    'سورة الأنعام',
    'سورة الأعراف',
    'سورة الأنفال',
    'سورة التوبة',
    'سورة يونس',
    'سورة هود',
    'أحكام التجويد',
    'المدود',
    'الإدغام',
    'الإقلاب',
    'الإخفاء',
    'القلقلة',
    'الغنة',
    'الوقف والابتداء',
    'التفخيم والترقيق',
    'أحكام النون الساكنة والتنوين',
  ];

  @override
  void initState() {
    super.initState();
    _updateControllerText();
  }

  void _updateControllerText() {
    widget.controller.text = _selectedTopics.join(', ');
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueViolet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.topic,
                  color: AppColors.primaryBlueViolet,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'المواضيع المغطاة',
                style: AppTextStyle.textStyle18.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlueViolet,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Selected Topics Display
          if (_selectedTopics.isNotEmpty) ...[
            Text(
              'المواضيع المحددة:',
              style: AppTextStyle.textStyle14.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlueViolet,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _selectedTopics.map((topic) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueViolet,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        topic,
                        style: AppTextStyle.textStyle12.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTopics.remove(topic);
                            _updateControllerText();
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
          ],

          // Common Topics Selection
          Text(
            'اختر من المواضيع الشائعة:',
            style: AppTextStyle.textStyle14.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),

          Container(
            height: 120.h,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _commonTopics.map((topic) {
                  final isSelected = _selectedTopics.contains(topic);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTopics.remove(topic);
                        } else {
                          _selectedTopics.add(topic);
                        }
                        _updateControllerText();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlueViolet.withOpacity(0.1)
                            : AppColors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlueViolet
                              : AppColors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        topic,
                        style: AppTextStyle.textStyle12.copyWith(
                          color: isSelected
                              ? AppColors.primaryBlueViolet
                              : AppColors.grey,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Custom Topic Input
          Text(
            'أو أضف موضوع مخصص:',
            style: AppTextStyle.textStyle14.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: AppTextStyle.textStyle14,
                  decoration: InputDecoration(
                    hintText: 'اكتب اسم الموضوع...',
                    hintStyle: AppTextStyle.textStyle14.copyWith(
                      color: AppColors.grey,
                    ),
                    filled: true,
                    fillColor: AppColors.grey.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primaryBlueViolet,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty &&
                        !_selectedTopics.contains(value.trim())) {
                      setState(() {
                        _selectedTopics.add(value.trim());
                        _updateControllerText();
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: 48.h,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueViolet,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle add custom topic
                  },
                  icon: Icon(Icons.add, color: AppColors.white, size: 20.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
