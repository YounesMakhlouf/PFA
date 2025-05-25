import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/utils/supabase_utils.dart';

class AvatarDisplay extends ConsumerWidget {
  final String? avatarUrlOrPath;
  final double radius;
  final Color? borderColor;
  final double borderWidth;

  const AvatarDisplay({
    super.key,
    this.avatarUrlOrPath,
    this.radius = 40,
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final logger = ref.read(loggingServiceProvider);

    ImageProvider? finalImageProvider;
    Widget? placeholderOrErrorWidget;

    if (avatarUrlOrPath != null && avatarUrlOrPath!.isNotEmpty) {
      if (avatarUrlOrPath!.startsWith('assets/')) {
        logger.debug("AvatarDisplay: Using local asset: $avatarUrlOrPath");
        try {
          finalImageProvider = AssetImage(avatarUrlOrPath!);
        } catch (e, st) {
          logger.warning(
              "AvatarDisplay: Failed to load local asset $avatarUrlOrPath",
              e,
              st);
          placeholderOrErrorWidget = _buildFallbackIcon(theme);
        }
      } else {
        // --- Handle Supabase Storage Path (construct full URL) ---
        final String? fullSupabaseUrl = getSupabasePublicUrl(
          ref,
          bucketId: StorageBuckets.avatars,
          filePath: avatarUrlOrPath,
        );

        if (fullSupabaseUrl != null) {
          logger.debug("AvatarDisplay: Using network image: $fullSupabaseUrl");
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: borderWidth > 0 && borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: fullSupabaseUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: radius * 2,
                  height: radius * 2,
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  child: Center(
                    child: SizedBox(
                      width: radius * 0.5,
                      height: radius * 0.5,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  logger.error(
                      "AvatarDisplay: Failed to load network image: $fullSupabaseUrl",
                      error);
                  return _buildFallbackIcon(theme, iconSizeMultiplier: 0.8);
                },
              ),
            ),
          );
        } else {
          logger.warning(
              "AvatarDisplay: Could not construct full URL for path: $avatarUrlOrPath");
          placeholderOrErrorWidget = _buildFallbackIcon(theme);
        }
      }
    } else {
      // No URL or path provided
      placeholderOrErrorWidget = _buildFallbackIcon(theme);
    }

    return Container(
      padding: borderWidth > 0 ? EdgeInsets.all(borderWidth) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: placeholderOrErrorWidget != null
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.transparent, // Background if no image
        backgroundImage: finalImageProvider,
        onBackgroundImageError: finalImageProvider != null
            ? (exception, stackTrace) {
                logger.error(
                    "AvatarDisplay: Error loading background asset: $avatarUrlOrPath",
                    exception,
                    stackTrace);
              }
            : null,
        child: placeholderOrErrorWidget, // Fallback icon if no image or error
      ),
    );
  }

  Widget _buildFallbackIcon(ThemeData theme,
      {double iconSizeMultiplier = 1.1}) {
    return Icon(
      Icons.person_outline_rounded,
      size: radius * iconSizeMultiplier,
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
    );
  }
}
