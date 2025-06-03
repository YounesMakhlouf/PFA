import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? valueStyle;
  final IconData? icon;
  final Color? iconColor;

  const StatItem({
    required this.title,
    required this.value,
    this.valueStyle,
    this.icon,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final TextStyle effectiveValueStyle = valueStyle ??
        textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        );
    final Color effectiveIconColor =
        iconColor ?? effectiveValueStyle.color ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      constraints: const BoxConstraints(minHeight: 88.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 28,
              color: effectiveIconColor,
            ),
            const SizedBox(height: 8.0),
          ],
          Text(
            value,
            style: effectiveValueStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
