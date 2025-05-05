import 'package:flutter/material.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [/*...*/],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headerTrailing ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatItem(
                  title: AppLocalizations.of(context).accuracy,
                  value: accuracy,
                  valueStyle: _statTextStyle(
                    value: _safeParsePercentage(accuracy),
                    higherIsBetter: true,
                  ),
              ),
              StatItem(
                  title:AppLocalizations.of(context).averageTime,
                  value: avgTime
              ),
              StatItem(
                  title: AppLocalizations.of(context).hintsUsed,
                  value: hintsUsed,
                  valueStyle: _statTextStyle(
                    value: _safeParsePercentage(hintsUsed),
                    higherIsBetter: false,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Colors the text based on value
  TextStyle _statTextStyle({required double? value, required bool higherIsBetter}) {
    if (value == null) return const TextStyle(color: Colors.black54);
    final color = (higherIsBetter ? value > 50 : value < 50)
        ? Colors.green
        : Colors.red;
    return TextStyle(color: color, fontWeight: FontWeight.bold);
  }
}
  /// Extract the numerical value from percentage text
  double? _safeParsePercentage(String value) {
    final cleaned = value.replaceAll('%', '').trim();
    if (cleaned == '--') return null;
    return double.tryParse(cleaned);
  }
