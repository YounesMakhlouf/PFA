import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/l10n/app_localizations.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final bool showCloseButton;

  const ErrorScreen({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.applicationError),
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.oopsSomethingWentWrong,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (onRetry != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.retryButton),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              if (onRetry != null &&
                  showCloseButton) // Add spacing if both buttons are shown
                const SizedBox(height: 12),
              if (showCloseButton)
                OutlinedButton.icon(
                  icon: const Icon(Icons.close_rounded),
                  label: Text(l10n.closeAppButton),
                  onPressed: () {
                    // This will attempt to close the application.
                    SystemNavigator.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(
                        color: colorScheme.error.withValues(alpha: 0.5)),
                  ),
                ),
              if (onRetry == null &&
                  !showCloseButton &&
                  Navigator.canPop(context))
                TextButton(
                  // Fallback to "Go Back" if it can pop
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.goBack),
                ),
              const SizedBox(height: 24),
              Text(
                l10n.errorScreenContactSupport,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
