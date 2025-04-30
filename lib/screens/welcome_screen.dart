import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SupaEmailAuth(
          localization: SupaEmailAuthLocalization(
            enterEmail: l10n.enterEmail,
            validEmailError: l10n.validEmailError,
            enterPassword: l10n.enterPassword,
            passwordLengthError: l10n.passwordLengthError,
            signIn: l10n.signIn,
            signUp: l10n.signUp,
            forgotPassword: l10n.forgotPassword,
            dontHaveAccount: l10n.dontHaveAccount,
            haveAccount: l10n.haveAccount,
            sendPasswordReset: l10n.sendPasswordReset,
            passwordResetSent: l10n.passwordResetSent,
            backToSignIn: l10n.backToSignIn,
            unexpectedError: l10n.unexpectedError,
            requiredFieldError: l10n.requiredFieldError,
            confirmPasswordError: l10n.confirmPasswordError,
            confirmPassword: l10n.confirmPassword,
          ),
          onSignInComplete: (response) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          onSignUpComplete: (response) {
            Navigator.pushReplacementNamed(
                context, AppRoutes.createChildProfile);
          },
          onError: (error) {
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
