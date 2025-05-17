import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pfa/utils/color_utils.dart';

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
    final Color effectiveForegroundColor = foregroundColor ??
        getContrastingForegroundColor(effectiveBackgroundColor);

    Widget cardContent;

    if (imagePath != null && imagePath!.isNotEmpty) {
      cardContent = CachedNetworkImage(
        imageUrl: imagePath!,
        fit: BoxFit.contain,
        errorWidget: (context, url, error) {
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
        elevation: isEnabled ? theme.cardTheme.elevation : 0.5,
        shape: theme.cardTheme.shape,
        clipBehavior: theme.cardTheme.clipBehavior,
        color: effectiveBackgroundColor,
        margin: theme.cardTheme.margin,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          splashColor: effectiveForegroundColor.withOpacity(0.1),
          highlightColor: effectiveForegroundColor.withOpacity(0.05),
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
                Expanded(
                  flex: 3,
                  child: Center(
                    child: cardContent,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  flex: 2,
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: effectiveForegroundColor,
                      fontWeight: FontWeight.w600,
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
