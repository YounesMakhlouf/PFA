import 'package:flutter/material.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/utils/color_utils.dart';

class CategoryCardWidget extends StatelessWidget {
  final GameCategory category;
  final VoidCallback? onTap;
  final bool isEnabled;

  const CategoryCardWidget({
    super.key,
    required this.category,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color effectiveBackgroundColor = category.themeColor;
    final Color effectiveForegroundColor =
        getContrastingForegroundColor(effectiveBackgroundColor);

    final String title = category.localizedName(context);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Card(
        elevation: isEnabled ? (theme.cardTheme.elevation ?? 2) : 0.5,
        shape: theme.cardTheme.shape,
        clipBehavior: theme.cardTheme.clipBehavior,
        color: effectiveBackgroundColor,
        margin: theme.cardTheme.margin,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          splashColor: theme.splashColor,
          highlightColor: theme.highlightColor,
          borderRadius: theme.cardTheme.shape is RoundedRectangleBorder
              ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                  as BorderRadius
              : BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon Area
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(
                      category.icon,
                      size: 60,
                      color: effectiveForegroundColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title Area
                Flexible(
                  flex: 1,
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: effectiveForegroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
