import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../data/models/progress_model.dart';

class DailyChartPainter extends CustomPainter {
  final List<DailyPerformance> dailyData;
  final double animationValue;

  DailyChartPainter({required this.dailyData, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyData.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final dotPaint = Paint()..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate dimensions (increased top margin for percentage labels)
    // Calculate dimensions (increased top margin for percentage labels)
    final chartHeight = size.height - 80;
    final chartWidth = size.width - 40;

    // Prevent division by zero if only one item
    final itemWidth = dailyData.length > 1
        ? chartWidth / (dailyData.length - 1)
        : chartWidth;

    // Find max value for scaling
    final maxValue = dailyData
        .map((e) => e.percentage)
        .reduce((a, b) => a > b ? a : b);

    // Check if maxValue is 0 to avoid division by zero later
    final scaledMaxValue = maxValue <= 0
        ? 100.0
        : (maxValue / 10).ceil() * 10.0;

    // Draw Y-axis labels
    _drawYAxisLabels(canvas, textPainter, chartHeight, scaledMaxValue);

    // Create gradient for line
    final gradient = LinearGradient(
      colors: [const Color(0xFF00E0FF), const Color(0xFF0077B6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = gradient.createShader(rect);

    // Create and draw chart paths
    final paths = _createChartPaths(itemWidth, chartHeight, scaledMaxValue);
    _drawChartArea(canvas, fillPaint, paths['fillPath']!, gradient, rect);
    canvas.drawPath(paths['linePath']!, paint);

    // Draw day labels and data points
    _drawDayLabels(canvas, textPainter, itemWidth, size);
    _drawDataPoints(
      canvas,
      dotPaint,
      textPainter,
      itemWidth,
      chartHeight,
      scaledMaxValue,
      gradient,
    );
  }

  void _drawYAxisLabels(
    Canvas canvas,
    TextPainter textPainter,
    double chartHeight,
    double scaledMaxValue,
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
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }
  }

  Map<String, Path> _createChartPaths(
    double itemWidth,
    double chartHeight,
    double scaledMaxValue,
  ) {
    final linePath = Path();
    final fillPath = Path();

    for (int i = 0; i < dailyData.length; i++) {
      final animatedIndex = (i * animationValue).clamp(0, dailyData.length - 1);
      if (animatedIndex < i) continue;

      final x = 40 + i * itemWidth;
      final normalizedValue = dailyData[i].percentage / scaledMaxValue;
      final y = chartHeight - (normalizedValue * chartHeight) + 40;

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, chartHeight + 40);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Complete fill path
    if (dailyData.isNotEmpty) {
      final lastX = 40 + (dailyData.length - 1) * itemWidth;
      fillPath.lineTo(lastX, chartHeight + 40);
      fillPath.close();
    }

    return {'linePath': linePath, 'fillPath': fillPath};
  }

  void _drawChartArea(
    Canvas canvas,
    Paint fillPaint,
    Path fillPath,
    LinearGradient gradient,
    Rect rect,
  ) {
    final fillGradient = LinearGradient(
      colors: [
        const Color(0xFF00E0FF).withOpacity(0.3),
        const Color(0xFF0077B6).withOpacity(0.1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    fillPaint.shader = fillGradient.createShader(rect);
    canvas.drawPath(fillPath, fillPaint);
  }

  void _drawDayLabels(
    Canvas canvas,
    TextPainter textPainter,
    double itemWidth,
    Size size,
  ) {
    for (int i = 0; i < dailyData.length; i++) {
      final animatedIndex = (i * animationValue).clamp(0, dailyData.length - 1);
      if (animatedIndex < i) continue;

      final x = 40 + i * itemWidth;

      // Draw day labels
      if (i % 2 == 0 || dailyData.length <= 7) {
        textPainter.text = TextSpan(
          text: dailyData[i].dayName,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 11,
            fontFamily: 'Cairo',
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 15),
        );
      }
    }
  }

  void _drawDataPoints(
    Canvas canvas,
    Paint dotPaint,
    TextPainter textPainter,
    double itemWidth,
    double chartHeight,
    double scaledMaxValue,
    LinearGradient gradient,
  ) {
    for (int i = 0; i < dailyData.length; i++) {
      final animatedIndex = (i * animationValue).clamp(0, dailyData.length - 1);
      if (animatedIndex < i) continue;

      final x = 40 + i * itemWidth;
      final normalizedValue = dailyData[i].percentage / scaledMaxValue;
      final y = chartHeight - (normalizedValue * chartHeight) + 40;

      // Draw data point circles
      _drawDataPointCircles(canvas, dotPaint, Offset(x, y), gradient);

      // Draw percentage labels
      _drawPercentageLabel(
        canvas,
        textPainter,
        Offset(x, y),
        dailyData[i].percentage,
      );
    }
  }

  void _drawDataPointCircles(
    Canvas canvas,
    Paint dotPaint,
    Offset center,
    LinearGradient gradient,
  ) {
    // Outer circle (white)
    dotPaint.color = Colors.white;
    canvas.drawCircle(center, 6, dotPaint);

    // Inner circle (gradient)
    dotPaint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: 4),
    );
    canvas.drawCircle(center, 4, dotPaint);
  }

  void _drawPercentageLabel(
    Canvas canvas,
    TextPainter textPainter,
    Offset point,
    double percentage,
  ) {
    textPainter.text = TextSpan(
      text: '${percentage.toInt()}%',
      style: const TextStyle(
        color: Color(0xFF0077B6),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    );
    textPainter.layout();

    // Position the text above the point with some padding
    final textY = point.dy - 25;
    final textX = point.dx - textPainter.width / 2;

    // Draw background for better readability
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        textX - 4,
        textY - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      ),
      const Radius.circular(4),
    );

    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Draw border around background
    final borderPaint = Paint()
      ..color = const Color(0xFF0077B6).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(backgroundRect, borderPaint);

    // Draw the percentage text
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
