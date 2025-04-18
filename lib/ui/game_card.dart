import 'package:flutter/material.dart';

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
    final CardTheme cardTheme = theme.cardTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        backgroundColor ?? cardTheme.color ?? colorScheme.secondary;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSecondary;

    Widget cardContent;
    if (imagePath != null && imagePath!.isNotEmpty) {
      cardContent = Image.asset(
        imagePath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback icon if image fails to load
          return Icon(
            Icons.broken_image_outlined,
            size: 50,
            color: effectiveForegroundColor.withOpacity(0.7),
          );
        },
      );
    } else if (iconData != null) {
      cardContent = Icon(
        iconData,
        size: 60, // Consistent size
        color: effectiveForegroundColor,
      );
    } else {
      // Default placeholder if neither image nor icon is provided
      cardContent = Icon(
        Icons.category, // Generic category icon
        size: 60,
        color: effectiveForegroundColor.withOpacity(0.7),
      );
    }

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: Card(
        elevation: isEnabled ? (cardTheme.elevation ?? 4) : 1,
        shape: cardTheme.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: cardTheme.clipBehavior ?? Clip.antiAlias,
        color: effectiveBackgroundColor,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          splashColor: effectiveForegroundColor.withOpacity(0.1),
          highlightColor: effectiveForegroundColor.withOpacity(0.05),
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
