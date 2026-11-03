import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

/// Translations for the auth form in the same three languages as the app.
class AppAuthLocalizations extends SupabaseAuthUILocalizations {
  AppAuthLocalizations(super.locale);

  bool get _isFrench => localeName == 'fr';
  bool get _isArabic => localeName == 'ar';

  String _text(String en, String fr, String ar) =>
      _isFrench ? fr : (_isArabic ? ar : en);

  @override
  String get enterEmail => _text('Email address', 'Adresse e-mail', 'البريد الإلكتروني');
  @override
  String get validEmailError => _text('Enter a valid email address', 'Saisissez une adresse e-mail valide', 'أدخل بريدًا إلكترونيًا صالحًا');
  @override
  String get enterPassword => _text('Password', 'Mot de passe', 'كلمة المرور');
  @override
  String get passwordLengthError => _text('Password must be at least 6 characters', 'Le mot de passe doit contenir au moins 6 caractères', 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل');
  @override
  String get signIn => _text('Sign in', 'Se connecter', 'تسجيل الدخول');
  @override
  String get signUp => _text('Create account', 'Créer un compte', 'إنشاء حساب');
  @override
  String get forgotPassword => _text('Forgot password?', 'Mot de passe oublié ?', 'هل نسيت كلمة المرور؟');
  @override
  String get dontHaveAccount => _text('New here?', 'Pas encore de compte ?', 'ليس لديك حساب؟');
  @override
  String get haveAccount => _text('Already registered?', 'Vous avez déjà un compte ?', 'لديك حساب بالفعل؟');
  @override
  String get sendPasswordReset => _text('Send reset link', 'Envoyer le lien de réinitialisation', 'إرسال رابط إعادة التعيين');
  @override
  String get passwordResetSent => _text('Password reset email sent', 'E-mail de réinitialisation envoyé', 'تم إرسال رسالة إعادة تعيين كلمة المرور');
  @override
  String get backToSignIn => _text('Back to sign in', 'Retour à la connexion', 'العودة إلى تسجيل الدخول');
  @override
  String get unexpectedError => _text('Something went wrong', 'Une erreur est survenue', 'حدث خطأ ما');
  @override
  String get requiredFieldError => _text('This field is required', 'Ce champ est obligatoire', 'هذا الحقل مطلوب');
  @override
  String get confirmPasswordError => _text('Passwords do not match', 'Les mots de passe ne correspondent pas', 'كلمتا المرور غير متطابقتين');
  @override
  String get confirmPassword => _text('Confirm password', 'Confirmer le mot de passe', 'تأكيد كلمة المرور');
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
