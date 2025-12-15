import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/main_button.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SelectionBottomSheet<T> extends StatefulWidget {
  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
    this.showSaveButton = false,
    this.saveButtonText,
  });
  final String title;
  final List<SelectionItem<T>> items;
  final T? selectedItem;
  final bool showSaveButton;
  final String? saveButtonText;

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<SelectionBottomSheet<T>> {
  late T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(
                    context,
                    widget.showSaveButton ? widget.selectedItem : _selectedItem,
                  ),
                ),
                Text(widget.title, style: AppTextStyle.medium16),
                SizedBox(width: 40.w), // For balance
              ],
            ),
            SizedBox(height: 16.h),
            ...widget.items.map(
              (item) => RadioListTile<T>(
                value: item.value,
                groupValue: _selectedItem,
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                  if (!widget.showSaveButton) {
                    Navigator.pop(context, value);
                  }
                },
                title: Text(item.label, style: AppTextStyle.regular16),
                activeColor: AppColors.primaryDark,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (widget.showSaveButton) ...[
              SizedBox(height: 16.h),
              AppDefaultButton(
                buttonText: widget.saveButtonText ?? 'Save',
                backgroundColor: AppColors.primaryDark,
                width: double.infinity,
                ontap: () => Navigator.pop(context, _selectedItem),
              ),
            ],
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}

class SelectionItem<T> {
  const SelectionItem({required this.label, required this.value});
  final String label;
  final T value;
}
