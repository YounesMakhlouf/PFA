import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/utils/supabase_utils.dart';

class OptionWidget extends ConsumerWidget {
  final Option option;
  final VoidCallback onTap;
  final Color? gameThemeColor;
  final bool isSelected; // for visual feedback in memory game
  final bool isDisabled;
  final bool isStory;

  const OptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    this.gameThemeColor,
    this.isSelected = false,
    this.isDisabled = false,
    this.isStory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final String? fullImageUrl = getSupabasePublicUrl(
      ref,
      bucketId: StorageBuckets.gameAssets,
      filePath: option.picturePath,
    );
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

    BoxDecoration decoration = BoxDecoration(
      borderRadius: borderRadius,
      border: isSelected
          ? Border.all(color: theme.colorScheme.secondary, width: 3)
          : null,
      boxShadow: (!isStory &&
              theme.cardTheme.elevation != null &&
              theme.cardTheme.elevation! > 0)
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
    final double size = isStory ? 180 : 100; // Bigger for story
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isStory ? Colors.transparent : theme.cardTheme.color,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.lightGrey.withAlpha((0.3 * 255).round()),
            child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0)),
          ),
          errorWidget: (context, error, stackTrace) {
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
