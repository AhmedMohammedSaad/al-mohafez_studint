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
    final chartWidth = size.width - 22;

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

    // Draw Y-axis labels removed (handled by external widget)

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

  Map<String, Path> _createChartPaths(
    double itemWidth,
    double chartHeight,
    double scaledMaxValue,
  ) {
    final linePath = Path();
    final fillPath = Path();

    // Prepare points
    final points = <Offset>[];
    for (int i = 0; i < dailyData.length; i++) {
      final x = 12 + i * itemWidth;
      final normalizedValue = dailyData[i].percentage / scaledMaxValue;
      final y = chartHeight - (normalizedValue * chartHeight) + 40;
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return {'linePath': linePath, 'fillPath': fillPath};

    linePath.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, chartHeight + 40);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // Calculate control points for a smooth curve
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);

      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Animate the path drawing by clipping it based on animation value
    // Note: Ideally, we would animate the path metrics, but for simplicity with the current setup,
    // we let the caller handle the drawing loop or we can clip the path here if needed.
    // However, the original code used `animatedIndex` inside the loop.
    // For bezier curves, partial drawing is harder.
    // Instead, we will draw the full path but use a PathMetric to extract a sub-path based on animationValue.

    final pathMetrics = linePath.computeMetrics();
    final animatedLinePath = Path();

    for (var metric in pathMetrics) {
      animatedLinePath.addPath(
        metric.extractPath(0, metric.length * animationValue),
        Offset.zero,
      );
    }

    // For fill path, we need to close it down to the bottom
    // We can just take the animated line path and close it.
    final animatedFillPath = Path.from(animatedLinePath);
    if (points.isNotEmpty && animationValue > 0) {
      // Find the last point on the animated path
      // Using `computeMetrics` again on the partial path is expensive but accurate.
      // A simpler approach for the fill is to drop down from the last point.

      final lastMetric = animatedLinePath.computeMetrics().lastOrNull;
      if (lastMetric != null) {
        final endPoint =
            lastMetric.getTangentForOffset(lastMetric.length)?.position ??
            points[0];
        animatedFillPath.lineTo(endPoint.dx, chartHeight + 40);
        animatedFillPath.lineTo(points[0].dx, chartHeight + 40);
        animatedFillPath.close();
      }
    }

    return {'linePath': animatedLinePath, 'fillPath': animatedFillPath};
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
        const Color(0xFF00E0FF).withValues(alpha: 0.3),
        const Color(0xFF0077B6).withValues(alpha: 0.1),
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
    final totalWidth = dailyData.length > 1
        ? (dailyData.length - 1) * itemWidth
        : 0;

    for (int i = 0; i < dailyData.length; i++) {
      final x = 12 + i * itemWidth;
      final currentMaxX = 12 + (totalWidth * animationValue);

      if (x > currentMaxX && dailyData.length > 1) continue;

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
    // We need to know the total length of the full path to map animationValue to x-coordinates
    // But since we built the path sequentially, we can roughly approximate progress by index
    // OR we can check if the current point's x overlaps with the drawn path.
    // simpler: usage of animationValue as a percentage of total width could work if the path is linear in x,
    // which it is (chart moves left to right).

    final totalWidth = dailyData.length > 1
        ? (dailyData.length - 1) * itemWidth
        : 0;

    for (int i = 0; i < dailyData.length; i++) {
      // Calculate x position for this point
      final x = 12 + i * itemWidth;

      // If total width is 0 (single item), show immediately if animation started.
      // Otherwise, check if this x is within the currently animated width.
      // currentAnimatedWidth approx = totalWidth * animationValue
      // We add a small buffer so points pop in slightly after the line passes them.

      final currentMaxX = 12 + (totalWidth * animationValue);

      if (x > currentMaxX && dailyData.length > 1) continue;

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
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Draw border around background
    final borderPaint = Paint()
      ..color = const Color(0xFF0077B6).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(backgroundRect, borderPaint);

    // Draw the percentage text
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
