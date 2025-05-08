import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';

class GameCardWidget extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final String? imagePath;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final bool isEnabled;

  const GameCardWidget({
    super.key,
    required this.title,
    this.iconData,
    this.imagePath,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color effectiveBackgroundColor = backgroundColor ??
        theme.cardTheme.color ??
        colorScheme.primaryContainer;
    final Color defaultForegroundColor =
        effectiveBackgroundColor.computeLuminance() > 0.5
            ? AppColors.textPrimary
            : AppColors.textLight;
    final Color effectiveForegroundColor =
        foregroundColor ?? defaultForegroundColor;

    Widget cardContent;

    if (imagePath != null && imagePath!.isNotEmpty) {
      cardContent = Image.network(
        imagePath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback icon if image fails to load
          return Icon(
            Icons.broken_image_outlined,
            size: 50,
            color: colorScheme.error.withAlpha((0.7 * 255).round()),
          );
        },
      );
    } else if (iconData != null) {
      cardContent = Icon(
        iconData,
        size: 60,
        color: effectiveForegroundColor,
      );
    } else {
      // Default placeholder if neither image nor icon is provided
      cardContent = Icon(
        Icons.category, // Generic category icon
        size: 60,
        color: theme.iconTheme.color?.withAlpha((0.7 * 255).round()) ??
            effectiveForegroundColor.withAlpha((0.7 * 255).round()),
      );
    }

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
                Flexible(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Center(
                      child: cardContent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
