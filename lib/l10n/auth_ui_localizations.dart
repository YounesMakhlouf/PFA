import 'package:arc_en_jeu/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AppAuthLocalizations extends SupabaseAuthUILocalizations {
  AppAuthLocalizations(super.locale);

  AppLocalizations get _app => lookupAppLocalizations(Locale(localeName));

  @override
  String get enterEmail => _app.enterEmail;
  @override
  String get validEmailError => _app.validEmailError;
  @override
  String get enterPassword => _app.enterPassword;
  @override
  String get passwordLengthError => _app.passwordLengthError;
  @override
  String get signIn => _app.signIn;
  @override
  String get signUp => _app.signUp;
  @override
  String get forgotPassword => _app.forgotPassword;
  @override
  String get dontHaveAccount => _app.dontHaveAccount;
  @override
  String get haveAccount => _app.haveAccount;
  @override
  String get sendPasswordReset => _app.sendPasswordReset;
  @override
  String get passwordResetSent => _app.passwordResetSent;
  @override
  String get backToSignIn => _app.backToSignIn;
  @override
  String get unexpectedError => _app.unexpectedError;
  @override
  String get requiredFieldError => _app.requiredFieldError;
  @override
  String get confirmPasswordError => _app.confirmPasswordError;
  @override
  String get confirmPassword => _app.confirmPassword;

  // These package strings aren't currently used by the email/password form.
  @override
  String get changePassword => 'Change password';
  @override
  String get checkYourEmail => 'Check your email';
  @override
  String get continueWithMagicLink => 'Continue with a magic link';
  @override
  String get enterCodeSent => 'Enter the code sent to you';
  @override
  String get enterNewPassword => 'Enter a new password';
  @override
  String get enterOneTimeCode => 'Enter the one-time code';
  @override
  String get enterOtpCode => 'Enter the verification code';
  @override
  String get enterPhoneNumber => 'Enter your phone number';
  @override
  String get otpCodeError => 'Enter a valid verification code';
  @override
  String get otpDisabledError => 'One-time password sign-in is unavailable';
  @override
  String get passwordChangedSuccess => 'Password changed successfully';
  @override
  String get successSignInMessage => 'Signed in successfully';
  @override
  String get updatePassword => 'Update password';
  @override
  String get validPhoneNumberError => 'Enter a valid phone number';
  @override
  String get verifyPhone => 'Verify phone number';
  @override
  String continueWithProvider(String provider) => 'Continue with $provider';
}

class AppAuthLocalizationsDelegate
    extends LocalizationsDelegate<SupabaseAuthUILocalizations> {
  const AppAuthLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => const ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<SupabaseAuthUILocalizations> load(Locale locale) =>
      SynchronousFuture(AppAuthLocalizations(locale.languageCode));

  @override
  bool shouldReload(AppAuthLocalizationsDelegate old) => false;
}
