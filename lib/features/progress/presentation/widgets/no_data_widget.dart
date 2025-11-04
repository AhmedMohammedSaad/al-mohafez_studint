import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NoDataWidget extends StatelessWidget {
  final double height;
  final String messageKey;
  final IconData? icon;
  final Color? iconColor;

  const NoDataWidget({
    Key? key,
    required this.height,
    this.messageKey = 'progress_chart_no_data',
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 48,
                color: iconColor ?? Colors.grey[400],
              ),
              const SizedBox(height: 16),
            ],
            Text(
              messageKey.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}