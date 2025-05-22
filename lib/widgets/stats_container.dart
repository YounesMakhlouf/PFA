import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/widgets/small_stat_box.dart';
import '../l10n/app_localizations.dart';

class StatsContainer extends StatelessWidget {
  final String title;
  final Widget? headerTrailing;
  final String accuracy;
  final String avgTime;
  final String hintsUsed;

  const StatsContainer({
    required this.title,
    this.headerTrailing,
    required this.accuracy,
    required this.avgTime,
    required this.hintsUsed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (headerTrailing != null) ...[
                const SizedBox(width: 16),
                headerTrailing!,
              ]
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StatItem(
                  title: l10n.accuracy,
                  value: accuracy,
                  icon: Icons.check_circle_outline,
                  valueStyle: _statTextStyle(
                    context,
                    value: _safeParsePercentage(accuracy),
                    higherIsBetter: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  title: l10n.averageTime,
                  value: avgTime,
                  icon: Icons.timer_outlined,
                  iconColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  title: l10n.hintsUsed,
                  value: hintsUsed,
                  icon: Icons.lightbulb_outline,
                  valueStyle: _statTextStyle(
                    context,
                    value: _safeParsePercentage(hintsUsed),
                    higherIsBetter: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Colors the text based on value
  TextStyle _statTextStyle(BuildContext context,
      {required double? value, required bool higherIsBetter}) {
    final theme = Theme.of(context);

    if (value == null) return TextStyle(color: theme.colorScheme.primary);
    final color = (higherIsBetter ? value > 50 : value < 50)
        ? AppColors.success
        : theme.colorScheme.error;
    return TextStyle(color: color, fontWeight: FontWeight.bold);
  }
}

/// Extract the numerical value from percentage text
double? _safeParsePercentage(String value) {
  final cleaned = value.replaceAll('%', '').trim();
  if (cleaned == '--') return null;
  return double.tryParse(cleaned);
}
