import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TimeFilterDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const TimeFilterDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    final List<DropdownMenuItem<String>> dropdownItems = [
      DropdownMenuItem(
          value: 'all', child: Text(l10n.all, style: textTheme.bodyLarge)),
      DropdownMenuItem(
          value: 'week',
          child: Text(l10n.periodThisWeek, style: textTheme.bodyLarge)),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
              colorScheme.outline.withValues(alpha: 0.7),
          width:
              theme.inputDecorationTheme.enabledBorder?.borderSide.width ?? 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: dropdownItems,
          onChanged: onChanged,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          iconSize: 28,
          isExpanded: true,
          dropdownColor: theme.cardTheme.color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          elevation: theme.popupMenuTheme.elevation?.toInt() ?? 4,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          selectedItemBuilder: (BuildContext context) {
            return dropdownItems.map<Widget>((DropdownMenuItem<String> item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (item.child as Text).data!,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
