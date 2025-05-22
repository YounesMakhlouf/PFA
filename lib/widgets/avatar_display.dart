import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/providers/global_providers.dart';

class AvatarDisplay extends ConsumerWidget {
  final String? avatarUrl;
  final double radius;

  const AvatarDisplay({
    super.key,
    this.avatarUrl,
    this.radius = 40,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement logic to handle both asset paths and Supabase URLs
    final logger = ref.read(loggingServiceProvider);
    ImageProvider? imageProvider;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('assets/')) {
        try {
          imageProvider = AssetImage(avatarUrl!);
          logger.debug("AvatarDisplay: Using local asset: $avatarUrl");
        } catch (e) {
          logger.warning("Failed to load avatar asset $avatarUrl", e);
        }
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      backgroundImage: imageProvider,
      onBackgroundImageError: imageProvider != null
          ? (_, __) {
              logger.error(
                  "AvatarDisplay: Error loading background image asset: $avatarUrl");
            }
          : null,
      child: imageProvider == null
          ? Icon(Icons.person, size: radius * 1.1) // Fallback Icon
          : null,
    );
  }
}
