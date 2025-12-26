import 'package:flutter/material.dart';
import '../../data/models/progress_model.dart';
import 'daily_chart_painter.dart';

class ChartPainterWidget extends StatefulWidget {
  final List<DailyPerformance> dailyData;
  final double height;
  final Duration animationDuration;

  const ChartPainterWidget({
    super.key,
    required this.dailyData,
    required this.height,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<ChartPainterWidget> createState() => _ChartPainterWidgetState();
}

class _ChartPainterWidgetState extends State<ChartPainterWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: CustomPaint(
                size: Size(
                  widget.dailyData.length * 60.0 + 60,
                  widget.height - 60,
                ),
                painter: DailyChartPainter(
                  dailyData: widget.dailyData,
                  animationValue: _animation.value,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
