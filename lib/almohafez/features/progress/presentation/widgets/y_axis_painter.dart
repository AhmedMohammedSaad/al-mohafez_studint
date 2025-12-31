import 'package:flutter/material.dart';
import '../../data/models/progress_model.dart';

class YAxisPainter extends CustomPainter {
  final List<DailyPerformance> dailyData;

  YAxisPainter({required this.dailyData});

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyData.isEmpty) return;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate dimensions (Same as DailyChartPainter)
    final chartHeight = size.height - 80;

    // Find max value for scaling (Same logic as DailyChartPainter)
    final maxValue = dailyData
        .map((e) => e.percentage)
        .reduce((a, b) => a > b ? a : b);

    final scaledMaxValue = maxValue <= 0
        ? 100.0
        : (maxValue / 10).ceil() * 10.0;

    // Draw Y-axis labels
    _drawYAxisLabels(
      canvas,
      textPainter,
      chartHeight,
      scaledMaxValue,
      size.width,
    );
  }

  void _drawYAxisLabels(
    Canvas canvas,
    TextPainter textPainter,
    double chartHeight,
    double scaledMaxValue,
    double width,
  ) {
    for (int i = 0; i <= 5; i++) {
      final value = (scaledMaxValue / 5) * i;
      final y = chartHeight - (chartHeight / 5) * i + 40;

      textPainter.text = TextSpan(
        text: '${value.toInt()}%',
        style: const TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      );
      textPainter.layout();
      // Align text to the right
      textPainter.paint(
        canvas,
        Offset(width - textPainter.width, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
