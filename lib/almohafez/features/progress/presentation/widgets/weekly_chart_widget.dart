import 'package:flutter/material.dart';
import '../../data/models/progress_model.dart';
import 'chart_header_widget.dart';
import 'no_data_widget.dart';
import 'chart_painter_widget.dart';

class DailyChartWidget extends StatelessWidget {
  final List<DailyPerformance> dailyData;
  final double height;

  const DailyChartWidget({
    super.key,
    required this.dailyData,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyData.isEmpty) {
      return NoDataWidget(
        height: height,
        messageKey: 'progress_chart_no_data',
        icon: Icons.show_chart,
        iconColor: const Color(0xFF0077B6),
      );
    }

    return Container(
      height: height + 100,
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
            const ChartHeaderWidget(
              titleKey: 'progress_chart_title',
              icon: Icons.trending_up,
              iconColor: Color(0xFF0077B6),
              backgroundColor: Color(0xFF0077B6),
            ),
            const SizedBox(height: 16),
            ChartPainterWidget(dailyData: dailyData, height: height),
          ],
        ),
      ),
    );
  }
}
