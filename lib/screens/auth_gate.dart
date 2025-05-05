import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/home_screen.dart';
import 'package:pfa/screens/welcome_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsyncValue = ref.watch(supabaseAuthStateProvider);
    final logger = ref.read(loggingServiceProvider);

    return authStateAsyncValue.when(
      data: (authState) {
        final session = authState.session;

        if (session != null) {
          // User is logged in
          logger.debug(
              "AuthGate: Session found (User ID: ${session.user.id}). Navigating to HomeScreen.");
          return const HomeScreen();
        } else {
          // User is logged out or session is null
          logger.debug(
              "AuthGate: No session found. Navigating to WelcomeScreen.");
          return const WelcomeScreen();
        }
      },
      loading: () {
        logger.debug("AuthGate: Auth state loading...");
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        logger.error("AuthGate: Error in auth stream", error, stackTrace);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: Theme.of(context).colorScheme.error, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).unexpectedError,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
