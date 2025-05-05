import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? valueStyle;

  const StatItem({
    required this.title,
    required this.value,
    this.valueStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.disabled),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: valueStyle ?? Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
            ),
          ],
        ),
      ),
    );
  }
}
