import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

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
    final sortedEntries = categoryAccuracies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sortedMap = Map.fromEntries(sortedEntries);
    final categories = sortedMap.keys.toList();
    final values = sortedMap.values.toList();
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey, width: 1),
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
              sideTitles: SideTitles(showTitles: true, reservedSize: 34),
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
                    final localized = getLocalizedLabel(keys[index],context);
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
                  color: values[i] > 50 ? Colors.green : Colors.red,
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

String getLocalizedLabel(String key, BuildContext context) {
  final loc = AppLocalizations.of(context);
  switch (key) {
    case 'NUMBERS':
      return loc.numbers;
    case 'EDUCATION':
      return loc.education;
    case 'RELAXATION':
      return loc.relaxation;
    case 'COLORS_SHAPES':
      return loc.colorsAndShapes;
    case 'EMOTIONS':
      return loc.emotions;
    case 'LOGICAL_THINKING':
      return loc.logicalThinking;
    case 'ANIMALS':
      return loc.animals;
    case 'FRUITS_VEGETABLES':
      return loc.fruitsAndVegetables;
    default:
      return key;
  }
}

