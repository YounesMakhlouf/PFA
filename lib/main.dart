import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/screens/error_screen.dart';
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
        child: MyApp(),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.authGate,
      routes: AppRoutes.routes,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
