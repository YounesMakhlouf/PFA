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
    ImageProvider? imageProvider;
    if (avatarUrl != null && avatarUrl!.startsWith('assets/')) {
      try {
        imageProvider = AssetImage(avatarUrl!);
      } catch (e) {
        ref
            .read(loggingServiceProvider)
            .warning("Failed to load avatar asset $avatarUrl", e);
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      backgroundImage: imageProvider,
      onBackgroundImageError: imageProvider != null
          ? (_, __) {
              ref
                  .read(loggingServiceProvider)
                  .error("Error loading background image asset: $avatarUrl");
            }
          : null,
      child: imageProvider == null
          ? Icon(Icons.person, size: radius * 1.2) // Fallback Icon
          : null,
    );
  }
}
