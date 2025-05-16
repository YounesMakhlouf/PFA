import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final bool isStory;
  final double size;

  const OptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    this.gameThemeColor,
    this.isSelected = false,
    this.isDisabled = false,
    this.size = 100.0,
    this.isStory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final String? fullImageUrl = getSupabasePublicUrl(
      ref,
      bucketId: StorageBuckets.gameAssets,
      filePath: option.picturePath,
    );
    Widget content;
    final Color effectiveContentColor =
        gameThemeColor ?? theme.colorScheme.onSurface;

    final BorderRadius borderRadius = BorderRadius.circular(12);

    if (fullImageUrl != null) {
      content = _buildImageOption(
          context, fullImageUrl, borderRadius, theme, ref, size);
    } else {
      content = _buildTextOption(
          context, option.labelText ?? '', effectiveContentColor, theme, size);
    }

    // Add selection/disabled visual cues
    BoxDecoration? selectionDecoration;
    if (isSelected) {
      selectionDecoration = BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: theme.colorScheme.primary, width: 3),
        color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
      );
    }

    // Use Semantics for accessibility
    return Semantics(
      button: true,
      label: option.labelText ?? l10n.selectableOption,
      value: isSelected ? l10n.selected : null,
      enabled: !isDisabled,
      explicitChildNodes: true,
      child: IgnorePointer(
        ignoring: isDisabled,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: GestureDetector(
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
            child: Container(
              width: size,
              height: size,
              decoration: selectionDecoration,
              child: ClipRRect(
                borderRadius: borderRadius,
                child: content,
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
