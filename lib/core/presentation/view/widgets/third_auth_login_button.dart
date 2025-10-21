import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_style.dart';

class ThirdAuthBtn extends StatelessWidget {
  const ThirdAuthBtn({super.key, required this.title, required this.icon, required this.onPressed});
  final String title;
  final SvgPicture icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        title,
        style: AppTextStyle.textButton.copyWith(
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.primary, width: 3),
        ),
        minimumSize: const Size(double.infinity, 60),
        alignment: Alignment.center,
      ),
    );
  }
}
