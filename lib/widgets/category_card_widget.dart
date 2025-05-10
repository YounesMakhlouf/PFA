import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/models/game.dart';

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
    // Determine foreground based on background luminance
    final Color effectiveForegroundColor =
        effectiveBackgroundColor.computeLuminance() > 0.5
            ? AppColors.textPrimary
            : AppColors.textLight;

    final String title = category.localizedName(context);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Card(
        elevation: isEnabled ? (theme.cardTheme.elevation ?? 2) : 0.5,
        shape: theme.cardTheme.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: theme.cardTheme.clipBehavior ?? Clip.antiAlias,
        color: effectiveBackgroundColor,
        margin: theme.cardTheme.margin ?? const EdgeInsets.all(4.0),
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
                FittedBox(
                  fit: BoxFit.scaleDown,
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
