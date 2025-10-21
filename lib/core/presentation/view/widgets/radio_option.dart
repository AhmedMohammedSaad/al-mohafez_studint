import 'package:flutter/material.dart';

class RadioOption extends StatelessWidget {
  const RadioOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.selectedColor = const Color(0xFF114C3A), // AppColors.darkGreen900
    this.unselectedColor = const Color(0xFFBDBDBD), // AppColors.gray6
    this.textStyle,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? selectedColor : unselectedColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedColor,
                        ),
                      ),
                    )
                  : null,
            ),

            // Space between radio and text
            const SizedBox(width: 16),

            // Option text
            Text(
              text,
              style: (textStyle ?? const TextStyle(fontSize: 16)).copyWith(
                color: selectedColor,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
