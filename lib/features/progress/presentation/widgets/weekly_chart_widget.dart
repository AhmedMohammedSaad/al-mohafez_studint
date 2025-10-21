import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/progress_model.dart';

class DailyChartWidget extends StatefulWidget {
  final List<DailyPerformance> dailyData;
  final double height;

  const DailyChartWidget({Key? key, required this.dailyData, this.height = 200})
    : super(key: key);

  @override
  State<DailyChartWidget> createState() => _DailyChartWidgetState();
}

class _DailyChartWidgetState extends State<DailyChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Auto scroll to the end to show latest data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dailyData.isEmpty) {
      return Container(
        height: widget.height,
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
          child: Text(
            'progress_chart_no_data'.tr(),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0077B6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF0077B6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'progress_chart_title'.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E3A59),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: CustomPaint(
                      size: Size(
                        widget.dailyData.length * 60.0 + 40,
                        widget.height - 60,
                      ),
                      painter: DailyChartPainter(
                        dailyData: widget.dailyData,
                        animationValue: _animation.value,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final chartHeight = size.height - 80;
    final chartWidth = size.width - 40;
    final itemWidth = chartWidth / (dailyData.length - 1);

    // Find max value for scaling
    final maxValue = dailyData
        .map((e) => e.percentage)
        .reduce((a, b) => a > b ? a : b);
    final scaledMaxValue = (maxValue / 10).ceil() * 10.0;

    // Draw Y-axis labels
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

    // Create gradient for line
    final gradient = LinearGradient(
      colors: [const Color(0xFF00E0FF), const Color(0xFF0077B6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = gradient.createShader(rect);

    // Create path for line chart
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < dailyData.length; i++) {
      final animatedIndex = (i * animationValue).clamp(0, dailyData.length - 1);
      if (animatedIndex < i) continue;

      final x = 40 + i * itemWidth;
      final normalizedValue = dailyData[i].percentage / scaledMaxValue;
      final y = chartHeight - (normalizedValue * chartHeight) + 40;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartHeight + 40);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

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

    // Complete fill path
    if (dailyData.isNotEmpty) {
      final lastX = 40 + (dailyData.length - 1) * itemWidth;
      fillPath.lineTo(lastX, chartHeight + 40);
      fillPath.close();

      // Draw fill area with gradient
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

    // Draw the line
    canvas.drawPath(path, paint);

    // Draw dots on data points
    for (int i = 0; i < dailyData.length; i++) {
      final animatedIndex = (i * animationValue).clamp(0, dailyData.length - 1);
      if (animatedIndex < i) continue;

      final x = 40 + i * itemWidth;
      final normalizedValue = dailyData[i].percentage / scaledMaxValue;
      final y = chartHeight - (normalizedValue * chartHeight) + 40;

      // Outer circle (white)
      dotPaint.color = Colors.white;
      canvas.drawCircle(Offset(x, y), 6, dotPaint);

      // Inner circle (gradient)
      dotPaint.shader = gradient.createShader(
        Rect.fromCircle(center: Offset(x, y), radius: 4),
      );
      canvas.drawCircle(Offset(x, y), 4, dotPaint);

      // Draw percentage value above each point
      textPainter.text = TextSpan(
        text: '${dailyData[i].percentage.toInt()}%',
        style: const TextStyle(
          color: Color(0xFF0077B6),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      );
      textPainter.layout();

      // Position the text above the point with some padding
      final textY = y - 25;
      final textX = x - textPainter.width / 2;

      // Draw a small background for better readability
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
