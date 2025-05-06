import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/providers/global_providers.dart';

class OptionWidget extends ConsumerWidget {
  final Option option;
  final VoidCallback onTap;
  final Color? gameThemeColor;
  final bool isSelected; // for visual feedback in memory game
  final bool isDisabled;

  const OptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    this.gameThemeColor,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final logger = ref.read(loggingServiceProvider);
    final bool hasImagePath =
        option.picturePath != null && option.picturePath!.isNotEmpty;

    String? fullImageUrl;
    if (hasImagePath) {
      try {
        final supabaseService = ref.read(supabaseServiceProvider);
        fullImageUrl = supabaseService.getPublicUrl(
          bucketId: 'game-assets',
          filePath: option.picturePath!,
        );
      } catch (e, stackTrace) {
        logger.error('Failed to get public URL for ${option.picturePath}', e,
            stackTrace);
      }
    }

    Widget content;
    final Color effectiveButtonColor =
        gameThemeColor ?? theme.colorScheme.primary;
    final BorderRadius borderRadius =
        theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                as BorderRadius
            : BorderRadius.circular(10);

    if (fullImageUrl != null) {
      content = _buildImageOption(context, fullImageUrl, borderRadius, theme);
    } else {
      content = _buildTextButtonOption(context, option.labelText ?? '',
          effectiveButtonColor, borderRadius, theme);
    }

    // Add selection/disabled visual cues
    BoxDecoration decoration = BoxDecoration(
      borderRadius: borderRadius,
      border: isSelected
          ? Border.all(color: theme.colorScheme.secondary, width: 3)
          : null,
      boxShadow:
          theme.cardTheme.elevation != null && theme.cardTheme.elevation! > 0
              ? const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
    );

    // Use Semantics for accessibility
    return Semantics(
      button: true,
      label: option.labelText ?? AppLocalizations.of(context).selectableOption,
      value: isSelected ? AppLocalizations.of(context).selected : null,
      enabled: !isDisabled,
      child: IgnorePointer(
        ignoring: isDisabled,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            decoration: decoration,
            child: Material(
              color: Colors.transparent,
              borderRadius: borderRadius,
              child: InkWell(
                onTap: isDisabled ? null : onTap,
                borderRadius: borderRadius,
                splashColor: theme.splashColor,
                highlightColor: theme.highlightColor,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption(BuildContext context, String imageUrl,
      BorderRadius borderRadius, ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: theme.cardTheme.color,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: theme.colorScheme.primary,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.error,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextButtonOption(BuildContext context, String text,
      Color buttonColor, BorderRadius borderRadius, ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: theme.cardTheme.color,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
