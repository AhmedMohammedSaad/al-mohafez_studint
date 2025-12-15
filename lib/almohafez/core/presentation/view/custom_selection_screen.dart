import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_default_text_form_field.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/main_button.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/generated/assets.dart';

class CustomSelectionScreen<T> extends StatefulWidget {
  const CustomSelectionScreen({
    super.key,
    required this.items,
    this.selectedItems = const [],
    this.withSearch = false,
    this.multiSelect = true,
    this.title = 'Select Item',
    this.searchHint = 'Search item...',
    this.clearAllText = 'Clear all',
    this.addButtonText = 'Add',
    required this.itemBuilder,
    this.itemLeadingBuilder,
    this.itemTrailingBuilder,
    this.isDialog = false,
    this.isBottomSheet = false,
  });
  final List<T> items;
  final List<T> selectedItems;
  final bool withSearch;
  final bool multiSelect;
  final String title;
  final String searchHint;
  final String clearAllText;
  final String addButtonText;
  final Widget Function(T item, bool isSelected) itemBuilder;
  final Widget Function(T item)? itemLeadingBuilder;
  final Widget Function(T item, bool isSelected)? itemTrailingBuilder;
  final bool isDialog;
  final bool isBottomSheet;

  @override
  State<CustomSelectionScreen<T>> createState() =>
      _CustomSelectionScreenState<T>();
}

class _CustomSelectionScreenState<T> extends State<CustomSelectionScreen<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> filteredItems = [];
  Set<T> selectedItems = {};

  @override
  void initState() {
    super.initState();
    filteredItems = List<T>.from(widget.items);
    selectedItems = Set<T>.from(widget.selectedItems);
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) {
        return item.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        if (widget.withSearch)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AppDefaultTextFormField(
              controller: _searchController,
              type: TextInputType.text,
              hint: widget.searchHint,
              prefixIcon: PrefixIconData.image(AssetData.svgSearch),
              onChange: (value) => filterItems(value),
              validate: (value) => null,
              required: false,
              textStyle: AppTextStyle.regular14,
              borderRadius: 100.r,
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              final isSelected = selectedItems.contains(item);
              return InkWell(
                onTap: () {
                  setState(() {
                    if (widget.multiSelect) {
                      if (isSelected) {
                        selectedItems.remove(item);
                      } else {
                        selectedItems.add(item);
                      }
                    } else {
                      selectedItems.clear();
                      selectedItems.add(item);
                      Navigator.of(
                        context,
                      ).pop({'selectedItems': selectedItems.toList()});
                    }
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: widget.itemBuilder(item, isSelected),
                ),
              );
            },
          ),
        ),
        if (widget.multiSelect)
          AppDefaultButton(
            buttonText: widget.addButtonText,
            ontap: () {
              Navigator.of(
                context,
              ).pop({'selectedItems': selectedItems.toList()});
            },
            buttonTextStyle: AppTextStyle.medium16.copyWith(
              color: Colors.white,
            ),
            backgroundColor: AppColors.primaryDark,
          ),
      ],
    );

    if (widget.isDialog) {
      return Container(
        width: double.infinity,
        // Use constraints to make the dialog taller but still fit within the screen
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.8, // 80% of screen height
          maxWidth:
              MediaQuery.of(context).size.width * 0.95, // 95% of screen width
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    widget.title,
                    style: AppTextStyle.medium16.copyWith(color: Colors.black),
                  ),
                  if (widget.multiSelect)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedItems.clear();
                        });
                      },
                      child: Text(
                        widget.clearAllText,
                        style: AppTextStyle.regular14.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 48.w), // Balance the layout
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            Expanded(child: content),
          ],
        ),
      );
    }

    // Bottom sheet mode
    if (widget.isBottomSheet) {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.99, // 90% of screen height
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            // Title row
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    widget.title,
                    style: AppTextStyle.medium16.copyWith(color: Colors.black),
                  ),
                  if (widget.multiSelect)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedItems.clear();
                        });
                      },
                      child: Text(
                        widget.clearAllText,
                        style: AppTextStyle.regular14.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 48.w),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: AppTextStyle.medium16.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.multiSelect)
            TextButton(
              onPressed: () {
                setState(() {
                  selectedItems.clear();
                });
              },
              child: Text(
                widget.clearAllText,
                style: AppTextStyle.regular14.copyWith(color: Colors.grey),
              ),
            ),
        ],
      ),
      body: content,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
