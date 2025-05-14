import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/create_child_profile_screen.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/generic_loading_screen.dart';
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
          logger.debug(
              "AuthGate: Session found (User ID: ${session.user.id}).  Checking initial profiles...");
          final profilesAsync = ref.watch(initialChildProfilesProvider);
          return profilesAsync.when(loading: () {
            logger.debug("AuthGate: Loading initial profiles...");
            return const GenericLoadingScreen(
                message: "Loading initial profiles..");
          }, error: (err, st) {
            logger.error("AuthGate: Error loading initial profiles", err, st);
            return ErrorScreen(
                errorMessage: AppLocalizations.of(context)
                    .errorLoadingProfileDetails(err));
          }, data: (profiles) {
            logger.debug(
                "AuthGate: Profiles loaded (${profiles.length}). Deciding screen...");
            if (profiles.isEmpty) {
              logger.debug(
                  "AuthGate: No profiles, showing CreateChildProfileScreen.");
              return const CreateChildProfileScreen();
            } else {
              logger.debug(
                  "AuthGate: Profiles exist. Showing HomeScreen. ActiveChildNotifier will handle active profile.");
              return const HomeScreen();
            }
          });
        } else {
          logger.debug(
              "AuthGate: No session found. Navigating to WelcomeScreen.");
          return const WelcomeScreen();
        }
      },
      loading: () {
        logger.debug("AuthGate: Auth state loading...");
        return GenericLoadingScreen(message: "Authenticating"); //TODO: Localize
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
