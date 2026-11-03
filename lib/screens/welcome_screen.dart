import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:arc_en_jeu/l10n/app_localizations.dart';
import 'package:arc_en_jeu/providers/global_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logger = ref.read(loggingServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SupaEmailAuth(
          onSignInComplete: (response) {
            logger.info(
                'SupaEmailAuth: Sign In Complete. User: ${response.user?.id}. AuthGate will handle navigation.');
          },
          onSignUpComplete: (response) {
            logger.info(
                'SupaEmailAuth: Sign Up Complete. User: ${response.user?.id}. AuthGate will handle navigation.');
          },
          onError: (error) {
            logger.error('SupaEmailAuth Error', error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('${l10n.applicationError}: ${error.toString()}')),
            );
          },
        ),
      ),
    );
  }
}
