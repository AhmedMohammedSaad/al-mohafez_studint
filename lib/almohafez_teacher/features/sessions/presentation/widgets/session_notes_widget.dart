import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SessionNotesWidget extends StatefulWidget {
  final TextEditingController notesController;
  final VoidCallback onSave;

  const SessionNotesWidget({
    super.key,
    required this.notesController,
    required this.onSave,
  });

  @override
  State<SessionNotesWidget> createState() => _SessionNotesWidgetState();
}

class _SessionNotesWidgetState extends State<SessionNotesWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isExpanded = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Icon(
                Icons.note_add_rounded,
                size: 24.sp,
                color: AppColors.primaryBlueViolet,
              ),
              SizedBox(width: 8.w),
              Text(
                'ملاحظات الجلسة',
                style: AppTextStyle.textStyle18Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (widget.notesController.text.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primarySuccess.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${widget.notesController.text.length} حرف',
                    style: AppTextStyle.textStyle12Medium.copyWith(
                      color: AppColors.primarySuccess,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),

          // حقل الملاحظات
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: TextFormField(
              controller: widget.notesController,
              focusNode: _focusNode,
              maxLines: _isExpanded ? 8 : 4,
              decoration: InputDecoration(
                hintText:
                    'اكتب ملاحظاتك حول الجلسة هنا...\n\n'
                    '• أداء الطالب\n'
                    '• النقاط المهمة\n'
                    '• التحسينات المطلوبة\n'
                    '• خطة الجلسة القادمة',
                hintStyle: AppTextStyle.textStyle14Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppColors.primaryBlueViolet,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                contentPadding: EdgeInsets.all(16.w),
              ),
              style: AppTextStyle.textStyle14Medium.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // أزرار الإجراءات
          Row(
            children: [
              // زر الحفظ السريع
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onSave,
                  icon: Icon(Icons.save_rounded, size: 18.sp),
                  label: Text(
                    'حفظ سريع',
                    style: AppTextStyle.textStyle14Medium,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlueViolet,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // زر المسح
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'مسح الملاحظات',
                        style: AppTextStyle.textStyle16Bold,
                      ),
                      content: Text(
                        'هل أنت متأكد من مسح جميع الملاحظات؟',
                        style: AppTextStyle.textStyle14Medium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'إلغاء',
                            style: AppTextStyle.textStyle14Medium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.notesController.clear();
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryError,
                          ),
                          child: Text(
                            'مسح',
                            style: AppTextStyle.textStyle14Medium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.clear_rounded, size: 18.sp),
                label: Text('مسح', style: AppTextStyle.textStyle14Medium),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryError.withOpacity(0.1),
                  foregroundColor: AppColors.primaryError,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),

          // نصائح سريعة
          if (_isExpanded) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlueViolet.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryBlueViolet.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        size: 16.sp,
                        color: AppColors.primaryBlueViolet,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'نصائح سريعة لكتابة ملاحظات فعالة:',
                        style: AppTextStyle.textStyle14Medium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• اذكر نقاط القوة والضعف\n'
                    '• حدد الأهداف للجلسة القادمة\n'
                    '• اكتب ملاحظات محددة وواضحة\n'
                    '• استخدم أمثلة من الجلسة',
                    style: AppTextStyle.textStyle12Medium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
