import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';

class GenericLoadingScreen extends ConsumerWidget {
  final String? message;
  final String? lottieAssetPath;
  final bool showAppBar;
  final String? appBarTitle;

  const GenericLoadingScreen({
    super.key,
    this.message,
    this.lottieAssetPath,
    this.showAppBar = false,
    this.appBarTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final String effectiveLottiePath =
        lottieAssetPath ?? 'assets/animations/default_loading.json';
    final String effectiveMessage = message ?? l10n.loading;

    Widget loadingContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Lottie.asset(
              effectiveLottiePath,
              repeat: true,
              animate: true,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to CircularProgressIndicator if Lottie fails
                final logger = ref.read(loggingServiceProvider);
                logger.error(
                    "Failed to load Lottie asset: $effectiveLottiePath",
                    error,
                    stackTrace);
                return CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                );
              },
            ),
          ),
          if (effectiveMessage.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              effectiveMessage,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(appBarTitle ?? l10n.loading),
              automaticallyImplyLeading: false,
            )
          : null,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: loadingContent,
    );
  }
}
