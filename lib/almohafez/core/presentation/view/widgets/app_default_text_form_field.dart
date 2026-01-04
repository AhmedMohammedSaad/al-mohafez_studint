import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

import 'app_custom_image_view.dart';

class AppDefaultTextFormField extends StatefulWidget {
  const AppDefaultTextFormField({
    super.key,
    required this.controller,
    required this.type,
    this.textInputFormatter,
    this.onChange,
    this.onSubmit,
    this.onTap,
    this.readOnly = false,
    required this.validate,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.suffixPressed,
    this.maxLength,
    this.required = true,
    this.obscureText = false,
    this.width = double.infinity,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.hintTextStyle,
    this.height,
    this.borderRadius = 12,
    this.borderColor,
    this.focusBorderColor,
    this.minLines = 1,
    this.maxLines = 1,
    this.focusNode,
    this.curserColor,
  });
  final TextEditingController controller;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType type;
  final Function? onChange;
  final Function? onSubmit;
  final Function? onTap;
  final String? Function(String?)? validate;
  final String? label;
  final String? hint;
  final bool readOnly;
  final PrefixIconData? prefixIcon;
  final Widget? suffix;
  final VoidCallback? suffixPressed;
  final int? maxLength;
  final bool required;
  final bool obscureText;
  final double width;
  final double? height;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? curserColor;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;

  @override
  State<AppDefaultTextFormField> createState() =>
      _AppDefaultTextFormFieldState();
}

class _AppDefaultTextFormFieldState extends State<AppDefaultTextFormField> {
  late final FocusNode _focusNode;
  bool isFocus = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: AppTextStyle.font14SecondaryW700.copyWith(
              color: AppColors.primary,
            ),
          ).paddingBottom(8.h),
        SizedBox(
          width: widget.width,
          height: widget.height, // Use the height if provided

          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.type,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            textAlign: widget.textAlign,
            textAlignVertical: TextAlignVertical.center,
            focusNode: _focusNode,
            maxLength: widget.maxLength,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            inputFormatters: widget.textInputFormatter,
            obscuringCharacter: '●',
            cursorColor: widget.curserColor,
            style:
                widget.textStyle ??
                AppTextStyle.font14SecondaryW700.copyWith(
                  color: AppColors.primaryColor2,
                ),
            onChanged: widget.onChange as void Function(String)?,
            onTap: widget.onTap as void Function()?,
            onFieldSubmitted: widget.onSubmit as void Function(String)?,
            validator: (value) {
              if (!widget.required && (value == null || value.isEmpty)) {
                return null;
              }
              final error = widget.validate?.call(value);
              setState(() {
                isError = error != null;
              });
              return error;
            },
            decoration: InputDecoration(
              errorMaxLines: 3,
              counterText: '',
              filled: true,
              fillColor: AppColors.white.withValues(alpha: 0.1),
              // Light grey background
              hintText: widget.hint,
              hintStyle:
                  widget.hintTextStyle ??
                  AppTextStyle.font14SecondaryW700.copyWith(
                    color: AppColors.mainWhite600,
                  ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.mainWhite600,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.mainWhite600,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                borderSide: BorderSide(
                  color: isFocus
                      ? widget.borderColor ?? AppColors.primary
                      : AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                borderSide: BorderSide(color: AppColors.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                borderSide: BorderSide(color: AppColors.error, width: 1),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 10.w,
                      ),
                      child: _buildPrefixIcon(),
                    )
                  : null,
              suffixIcon: widget.suffix != null
                  ? GestureDetector(
                      onTap: widget.suffixPressed,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        child: widget.suffix,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrefixIcon() {
    if (widget.prefixIcon == null) return const SizedBox();

    if (widget.prefixIcon!.icon != null) {
      return Icon(
        widget.prefixIcon!.icon,
        color: widget.prefixIcon!.iconColor,
        size: widget.prefixIcon!.size,
      );
    }

    if (widget.prefixIcon!.text != null) {
      return Text(
        widget.prefixIcon!.text!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: widget.prefixIcon!.size ?? 16.0,
          color: widget.prefixIcon!.iconColor ?? AppColors.black,
        ),
      );
    }

    return AppCustomImageView(
      imagePath: widget.prefixIcon!.imagePath!,
      height: widget.prefixIcon!.size,
      width: widget.prefixIcon!.size,
      fit: BoxFit.contain,
      color: widget.prefixIcon?.iconColor,
    );
  }
}

class PrefixIconData {
  const PrefixIconData({
    this.imagePath,
    this.icon,
    this.iconColor,
    this.size,
    this.text,
  }) : assert(
         imagePath != null || icon != null || text != null,
         'Either imagePath, icon, or text must be provided',
       );

  factory PrefixIconData.image(String path, {double? size, Color? color}) {
    return PrefixIconData(imagePath: path, size: size, iconColor: color);
  }

  factory PrefixIconData.icon(IconData icon, {Color? color, double? size}) {
    return PrefixIconData(icon: icon, iconColor: color, size: size);
  }

  factory PrefixIconData.text(String text) {
    return PrefixIconData(text: text);
  }
  final String? imagePath;
  final IconData? icon;
  final Color? iconColor;
  final double? size;
  final String? text;
}
