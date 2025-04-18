import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'config/routes.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggingService();
  logger.initialize();

  try {
    await SupabaseService().initialize();
    runApp(const MyApp());
  } catch (e, stackTrace) {
    logger.error('Failed to initialize app', e, stackTrace);
    // Show error UI instead of crashing
    runApp(ErrorScreen(errorMessage: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
