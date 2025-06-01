import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/utils/supabase_utils.dart';

class OptionWidget extends ConsumerWidget {
  final Option option;
  final VoidCallback onTap;
  final Color? gameThemeColor;
  final bool isSelected; // for visual feedback in memory game
  final bool isDisabled;
  final bool isRevealed; // Memory Game: Show face or back
  final bool isMatched; // Memory Game: Is part of a successfully matched pair
  final bool isStory;
  final double size;

  const OptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    this.gameThemeColor,
    this.isSelected = false,
    this.isDisabled = false,
    this.isRevealed = true,
    this.isMatched = false,
    this.size = 100.0,
    this.isStory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final String? fullImageUrl = getSupabasePublicUrl(
      ref,
      bucketId: StorageBuckets.gameAssets,
      filePath: option.picturePath,
    );
    final Color effectiveContentColor =
        gameThemeColor ?? theme.colorScheme.onSurface;

    final BorderRadius borderRadius = BorderRadius.circular(12);
    Widget cardFaceContent;
    if (fullImageUrl != null) {
      cardFaceContent = _buildImageOption(
          context, fullImageUrl, borderRadius, theme, ref, size);
    } else {
      cardFaceContent = _buildTextOption(
          context, option.labelText ?? '', effectiveContentColor, theme, size);
    }

    Widget displayContent;
    if (isRevealed) {
      displayContent = cardFaceContent;
    } else {
      // Card Back UI for Memory Game
      displayContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.8),
          // Consistent card back
          borderRadius: borderRadius,
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        ),
        child: Center(
          child: Icon(
            Icons.question_mark_rounded,
            size: size * 0.5,
            color:
                theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    Color cardBackgroundColor = gameThemeColor ??
        theme.cardTheme.color ??
        theme.colorScheme.surfaceContainerHighest;

    ShapeBorder cardShape = theme.cardTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

    if (isMatched) {
      cardBackgroundColor = AppColors.success.withValues(alpha: 0.25);
      if (cardShape is RoundedRectangleBorder) {
        cardShape = cardShape.copyWith(
          side: BorderSide(
              color: AppColors.success.withValues(alpha: 0.6), width: 2),
        );
      }
    } else if (isSelected) {
      cardBackgroundColor = cardBackgroundColor.withValues(alpha: 0.9);
      if (cardShape is RoundedRectangleBorder) {
        cardShape = cardShape.copyWith(
          side: BorderSide(color: theme.colorScheme.primary, width: 3),
        );
      }
    }

    // Final opacity for disabled and matched states
    double finalOpacity = 1.0;
    if (isDisabled && !isRevealed) {
      // Hidden and disabled (not part of current pair attempt)
      finalOpacity = 0.6;
    } else if (isDisabled && isRevealed && !isMatched) {
      // Revealed (selected) but disabled (e.g. pair attempt)
      finalOpacity = 0.8;
    } else if (isMatched) {
      finalOpacity = 0.7;
    }
    if (isDisabled && isMatched) {
      finalOpacity = 0.7;
    }

    // Use Semantics for accessibility
    return Semantics(
      button: true,
      label: option.labelText ??
          (fullImageUrl != null ? l10n.imageOption : l10n.selectableOption),
      value: isSelected ? l10n.selected : (isMatched ? "matched" : null),
      // TODO: Add "matched" to l10n
      enabled: !isDisabled,
      explicitChildNodes: true,
      child: IgnorePointer(
        ignoring: isDisabled,
        child: Opacity(
          opacity: finalOpacity,
          child: SizedBox(
            width: size,
            height: size,
            child: Card(
              elevation: !isDisabled ? theme.cardTheme.elevation : 0.5,
              shape: theme.cardTheme.shape,
              clipBehavior: theme.cardTheme.clipBehavior ?? Clip.antiAlias,
              color: cardBackgroundColor,
              margin: EdgeInsets.zero,
              child: InkWell(
                onTap: isDisabled
                    ? null
                    : () {
                        final bool hapticsAreEnabled =
                            ref.read(hapticsEnabledProvider);
                        if (hapticsAreEnabled) {
                          HapticFeedback.lightImpact();
                        }
                        onTap();
                      },
                borderRadius: borderRadius,
                splashColor: effectiveContentColor.withValues(alpha: 0.12),
                highlightColor: effectiveContentColor.withValues(alpha: 0.08),
                child: displayContent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption(BuildContext context, String imageUrl,
      BorderRadius borderRadius, ThemeData theme, WidgetRef ref, double size) {
    final logger = ref.read(loggingServiceProvider);
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: theme.colorScheme.surfaceContainerHighest
                .withAlpha((0.3 * 255).round()),
            child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2.0, color: theme.colorScheme.primary)),
          ),
          errorWidget: (context, url, error) {
            logger.error("OptionWidget: Image Network Error", error);
            return Container(
              // Fallback visual within the bounds
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withAlpha((0.1 * 255).round()),
                borderRadius: borderRadius,
              ),
              child: Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: theme.colorScheme.onSurfaceVariant
                      .withAlpha((0.5 * 255).round()),
                  size: size * 0.6,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextOption(BuildContext context, String text, Color contentColor,
      ThemeData theme, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ),
    );
  }
}
