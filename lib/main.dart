import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/auth_gate.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/generic_loading_screen.dart';
import 'package:pfa/screens/onboarding_screen.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'config/routes.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> initializeAppServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggingService();
  logger.initialize();

  logger.info('Initializing Supabase Service...');
  try {
    await SupabaseService(logger).initialize();
    logger.info('Supabase Service initialization complete.');
  } catch (e, stackTrace) {
    logger.error('Failed during Supabase initialization', e, stackTrace);
    rethrow;
  }
}

void main() async {
  initializeAppServices().then((_) {
    runApp(
      const ProviderScope(
        child: AppInitializer(),
      ),
    );
  }).catchError((error, stackTrace) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ErrorScreen(
          errorMessage: "App failed to initialize: ${error.toString()}"),
    ));
  });
}

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboardingAsync = ref.watch(onboardingCompletedProvider);

    return hasCompletedOnboardingAsync.when(
      data: (hasCompleted) {
        return MyApp(showOnboarding: !hasCompleted);
      },
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GenericLoadingScreen(),
      ),
      error: (err, stack) {
        ref
            .read(loggingServiceProvider)
            .error("Error checking onboarding status", err, stack);
        return const MyApp(showOnboarding: true);
      },
    );
  }
}

class MyApp extends ConsumerWidget {
  final bool showOnboarding;
  const MyApp({required this.showOnboarding, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,
      home: showOnboarding ? const OnboardingScreen() : const AuthGate(),
      locale: currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    );
  }
}
