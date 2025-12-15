import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChartHeaderWidget extends StatelessWidget {
  final String titleKey;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const ChartHeaderWidget({
    Key? key,
    required this.titleKey,
    this.icon = Icons.trending_up,
    this.iconColor = const Color(0xFF0077B6),
    this.backgroundColor = const Color(0xFF0077B6),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          titleKey.tr(),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
      ],
    );
  }
}