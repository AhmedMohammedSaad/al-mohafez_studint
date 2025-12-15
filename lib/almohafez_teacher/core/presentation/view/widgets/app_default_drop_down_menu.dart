import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/utils/app_strings.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/search_text_field_widget.dart';

import 'package:almohafez/generated/assets.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

import 'dart:async';

class AppCustomDropdownMenuWidget extends StatefulWidget {
  // Add the onChanged callback

  const AppCustomDropdownMenuWidget({
    super.key,
    required this.optionsList,
    required this.hint,
    this.leadingIconPath,
    required this.controller,
    this.statusList,
    this.enabled = true,
    this.width,
    this.height,
    this.text,
    this.onChanged, // Initialize the onChanged parameter
  });
  final List<String> optionsList;
  final List<bool>? statusList;
  final String hint;
  final String? leadingIconPath;
  final TextEditingController controller;
  final bool enabled;
  final double? width;
  final double? height;
  final String? text;
  final Function(String)? onChanged;

  @override
  AppCustomDropdownMenuWidgetState createState() =>
      AppCustomDropdownMenuWidgetState();
}

class AppCustomDropdownMenuWidgetState
    extends State<AppCustomDropdownMenuWidget> {
  String? _selectedItem;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  Timer? _debounce;
  late List<String> filteredList;
  final ValueNotifier<List<String>> _filteredListNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.controller.text.isNotEmpty
        ? widget.controller.text
        : null;
    filteredList = List.from(widget.optionsList);
    _filteredListNotifier.value = filteredList; // Initialize the notifier
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      filteredList = List.from(widget.optionsList);
      _filteredListNotifier.value = filteredList;
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(AppCustomDropdownMenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.optionsList != oldWidget.optionsList ||
        widget.enabled != oldWidget.enabled) {
      if (!widget.optionsList.contains(_selectedItem)) {
        setState(() {
          _selectedItem = null;
        });
      }
      filteredList = List.from(widget.optionsList);
      _filteredListNotifier.value = filteredList;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _overlayEntry?.remove();
    _filteredListNotifier.dispose(); // Dispose the notifier
    super.dispose();
  }

  void _filterList(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _filteredListNotifier.value = List.from(widget.optionsList);
      } else {
        _filteredListNotifier.value = widget.optionsList
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final TextEditingController searchController = TextEditingController();

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 300, // Fixed width
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked:
                false, // Set to false to hide when scrolled out of view
            offset: Offset(
              0,
              widget.text == null ? size.height : size.height - 50.h,
            ),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(4.r),
              child: Container(
                width: 300, // Fixed width
                height: 300, // Fixed height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search TextField
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: SearchWidgetTextField(
                        controller: searchController,
                        hintText: '${AppStrings.search}...',
                        onChanged: _filterList,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide(
                            color: AppColors.grayTextForm,
                            width: 1.0.w,
                          ),
                        ),
                      ),
                    ),
                    // List View
                    Expanded(
                      child: ValueListenableBuilder<List<String>>(
                        valueListenable: _filteredListNotifier,
                        builder: (context, filteredItems, _) {
                          return filteredItems.isNotEmpty
                              ? ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemCount: filteredItems.length,
                                  separatorBuilder: (context, index) => Divider(
                                    color: AppColors.grey,
                                    height: 1.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    final String item = filteredItems[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedItem = item;
                                          widget.controller.text = item;
                                        });
                                        widget.onChanged?.call(item);
                                        _overlayEntry?.remove();
                                        _overlayEntry = null;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedItem == item
                                              ? AppColors.primary.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.transparent,
                                        ),
                                        child: Text(
                                          item,
                                          style: AppTextStyle.font16black700,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text(
                                      AppStrings.noResultFound,
                                      style: AppTextStyle.font16black700,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.text != null
            ? Text(widget.text!, style: AppTextStyle.font16black700)
            : const SizedBox.shrink(),
        SizedBox(height: widget.text != null ? 16.0 : 0.0),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: widget.enabled ? _toggleDropdown : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _overlayEntry == null
                        ? AppColors.grey
                        : AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: widget.leadingIconPath != null ? 24.0 : 0,
                    height: widget.leadingIconPath != null ? 24.0 : 0,
                    child: widget.leadingIconPath != null
                        ? AppCustomImageView(imagePath: widget.leadingIconPath)
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _selectedItem ?? widget.hint,
                      style: _selectedItem != null
                          ? AppTextStyle.font16black700
                          : AppTextStyle.font14SecondaryW700,
                    ),
                  ),
                  AppCustomImageView(
                    imagePath: _overlayEntry == null
                        ? AssetData.svgCustomDropDownMenuArrowDown
                        : AssetData.svgUpArrowIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
