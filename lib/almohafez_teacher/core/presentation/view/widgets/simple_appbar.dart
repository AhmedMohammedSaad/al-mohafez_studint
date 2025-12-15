import 'package:almohafez/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'app_custom_image_view.dart';

class AppSimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppSimpleAppBar({
    super.key,
    this.title,
    this.isBack = false,
    this.centerTitle = true,
    this.appBarheight = 60,
    this.backgroundColor,
    this.titleStyle,
    this.actions,
  });
  final String? title;
  final bool centerTitle;
  final double? appBarheight;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final bool? isBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      elevation: 0,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      actions: actions,
      title: Text(
        title ?? '',
        style:
            titleStyle ??
            TextStyle(
              fontSize: 18.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
        textAlign: TextAlign.center,
      ).visible(title.validate().isNotEmpty),
      centerTitle: centerTitle,
      leading: Container(
        width: 40.w,
        height: 40.h,
        alignment: Alignment.center,
        child: isBack == true
            ? AppCustomImageView(
                imagePath: context.locale.languageCode == 'ar'
                    ? AssetData.svgRightArrowIcon
                    : AssetData.svgLeftArrowIcon,
                width: 24.w,
                height: 24.h,
                color: AppColors.primaryDark,
                onTap: () {
                  finish(context);
                },
              )
            : null,
      ).paddingSymmetric(horizontal: 10.w),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(appBarheight ?? 100.h);
}
