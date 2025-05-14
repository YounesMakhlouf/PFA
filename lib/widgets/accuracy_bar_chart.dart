import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import '../utils/category_localization_utils.dart';

class AccuracyBarChart extends StatelessWidget {
  final Map<String, double> categoryAccuracies;
  final BuildContext context;

  const AccuracyBarChart({
    required this.categoryAccuracies,
    required this.context,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // sort categories by accuracy in descending order
    final categories = categoryAccuracies.keys.toList();
    final values = categoryAccuracies.values.toList();
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(
            show: true,
            border: Border.all(color:AppColors.disabled, width: 1),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 44),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 70,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final keys = categoryAccuracies.keys.toList();
                  if (index >= 0 && index < keys.length) {
                    final localized = getLocalizedCategory(keys[index],context);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Transform.rotate(
                        angle: -0.6,
                        child: Text(
                          localized,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: List.generate(categories.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i] > 0 ? values[i] : 0.5,
                  width: 30,
                  color: values[i] > 50 ? AppColors.success : AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}


