import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import '../utils/category_localization_utils.dart';

class AccuracyBarChart extends StatelessWidget {
  final Map<String, double> categoryAccuracies;

  const AccuracyBarChart({
    required this.categoryAccuracies,
    super.key,
  });
  Color _getBarColor(double accuracy, ThemeData theme) {
    if (accuracy >= 80) {
      return AppColors.success;
    } else if (accuracy >= 50) {
      return theme.colorScheme.primary;
    } else if (accuracy > 0) {
      return theme.colorScheme.secondary;
    }
    return theme.colorScheme.error.withValues(alpha: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // sort categories by accuracy in descending order
    final categories = categoryAccuracies.keys.toList();
    final values = categoryAccuracies.values.toList();
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5), width: 1),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: colorScheme.outline.withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false,
          ),
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          minY: 0,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
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
                reservedSize: 65,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < categories.length) {
                    final localizedCategoryName =
                        getLocalizedCategory(categories[index], context);
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Transform.rotate(
                        angle: -0.7,
                        alignment: Alignment.centerRight,
                        child: Text(
                          localizedCategoryName,
                          style: textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
            final accuracy = values[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: accuracy > 0 ? accuracy : 0.5,
                  width: 22,
                  color: _getBarColor(accuracy, theme),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  borderSide: BorderSide(color: colorScheme.outline, width: 1),
                ),
              ],
            );
          }),
          backgroundColor:
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}
