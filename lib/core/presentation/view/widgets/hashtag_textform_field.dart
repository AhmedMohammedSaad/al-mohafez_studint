import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/core/models/hashtag_model.dart';
import 'package:almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/core/theme/app_colors.dart';
import 'package:almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/generated/assets.dart';

class HashtagInputField extends StatefulWidget {
  const HashtagInputField({
    super.key,
    required this.selectedHashtags,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onChangedChips,
    this.readOnly = false,
    this.onTap,
    this.isHashtag = true,
  });
  final List<HashtagModel> selectedHashtags;
  final TextEditingController controller;
  final String hint;
  final Function(String)? onChanged;
  final Function(HashtagModel)? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<List<HashtagModel>>? onChangedChips;
  final bool isHashtag;

  @override
  HashtagInputFieldState createState() => HashtagInputFieldState();
}

class HashtagInputFieldState extends State<HashtagInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isBackspacePressed = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (widget.controller.text.isEmpty && _isBackspacePressed) {
      final nonEmptyHashtags = widget.selectedHashtags
          .where((hashtag) => hashtag.name.isNotEmpty)
          .toList();

      if (nonEmptyHashtags.isNotEmpty) {
        final updatedHashtags = List<HashtagModel>.from(
          widget.selectedHashtags,
        );
        updatedHashtags.remove(nonEmptyHashtags.last);
        widget.onChangedChips?.call(updatedHashtags);
      }
      _isBackspacePressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly ? widget.onTap : () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: widget.isHashtag ? 0 : 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Row(
          children: [
            if (!widget.isHashtag)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: (widget.selectedHashtags.isNotEmpty) ? 15 : 10.h,
                  horizontal: (widget.selectedHashtags.isNotEmpty) ? 0 : 10.w,
                ),
                child: (widget.selectedHashtags.isNotEmpty)
                    ? null
                    : const AppCustomImageView(imagePath: AssetData.svgTags),
              ),

            Expanded(
              child: Wrap(
                spacing: 4,
                runSpacing: 8,
                children: [
                  ...widget.selectedHashtags
                      .where((hashtag) => hashtag.name.isNotEmpty)
                      .map(
                        (hashtag) => Container(
                          decoration: ShapeDecoration(
                            color: AppColors.secondaryGreen300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              '# ${hashtag.name}',
                              style: AppTextStyle.regular14,
                            ),
                          ),
                        ),
                      ),
                  if (!widget.readOnly)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: IntrinsicWidth(
                        child: KeyboardListener(
                          focusNode: _focusNode,
                          onKeyEvent: (KeyEvent event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.backspace &&
                                widget.controller.text.isEmpty) {
                              _isBackspacePressed = true;
                            }
                          },
                          child: TextFormField(
                            controller: widget.controller,
                            readOnly: widget.readOnly,
                            decoration: InputDecoration(
                              hintText: widget.hint,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                            minLines: 1,
                            maxLines: 10,
                            onChanged: widget.onChanged,
                            onFieldSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                final newHashtag = HashtagModel(
                                  id: '',
                                  name: value.trim(),
                                  outfits: 0,
                                  status: 'ACTIVE',
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );

                                widget.onSubmitted?.call(newHashtag);
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  else if (widget.selectedHashtags.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Text(widget.hint, style: AppTextStyle.regular16),
                    ),
                ],
              ),
            ),

            // Add suffix icon (chevron right)
            if (widget.readOnly)
              Icon(Icons.chevron_right, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }
}
