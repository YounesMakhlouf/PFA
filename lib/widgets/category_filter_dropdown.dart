import 'package:flutter/material.dart';
import 'package:pfa/models/category_option.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final List<CategoryOption> categories;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    required this.value,
    required this.categories,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor ??
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.value,
              child: Text(
                category.label,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
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
          selectedItemBuilder: (BuildContext context) {
            return categories.map<Widget>((CategoryOption item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.label,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
