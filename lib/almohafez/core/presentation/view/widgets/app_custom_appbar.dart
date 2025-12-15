import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/generated/assets.dart';

import 'app_custom_image_view.dart';

class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Add this

  const AppCustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.appBarHeight,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.onBackPressed,
    this.titleStyle,
    this.leading,
    this.bottom, // Add this
  });
  final String title;
  final bool centerTitle;
  final double? appBarHeight;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final TextStyle? titleStyle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      centerTitle: centerTitle,
      title: Text(
        title,
        style:
            titleStyle ??
            const TextStyle(
              color: Color(0xFF0E0E0E),
              fontSize: 16,
              fontFamily: 'Neulis Sans',
              fontWeight: FontWeight.w600,
              height: 1.40,
            ),
      ),
      leading: showBackButton
          ? leading ??
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: AppCustomImageView(
                      width: 24.w,
                      height: 24.h,
                      imagePath: context.locale.languageCode == 'ar'
                          ? AssetData.svgRightArrowIcon
                          : AssetData.svgLeftArrowIcon,
                      color: AppColors.primaryDark,
                      onTap: () {
                        finish(context);
                      },
                    ),
                  ),
                )
          : null,
      actions: actions,
      bottom: bottom, // Add this
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (appBarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
  );
}
