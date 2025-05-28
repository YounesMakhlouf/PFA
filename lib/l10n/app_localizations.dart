import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق تعلم التوحد'**
  String get appTitle;

  /// No description provided for @learningGames.
  ///
  /// In ar, this message translates to:
  /// **'ألعاب التعلم'**
  String get learningGames;

  /// No description provided for @logicalThinking.
  ///
  /// In ar, this message translates to:
  /// **'التفكير المنطقي'**
  String get logicalThinking;

  /// No description provided for @education.
  ///
  /// In ar, this message translates to:
  /// **'التعليم'**
  String get education;

  /// No description provided for @relaxation.
  ///
  /// In ar, this message translates to:
  /// **'الاسترخاء'**
  String get relaxation;

  /// No description provided for @emotions.
  ///
  /// In ar, this message translates to:
  /// **'المشاعر'**
  String get emotions;

  /// No description provided for @numbers.
  ///
  /// In ar, this message translates to:
  /// **'الأرقام'**
  String get numbers;

  /// No description provided for @colorsAndShapes.
  ///
  /// In ar, this message translates to:
  /// **'ألوان وأشكال'**
  String get colorsAndShapes;

  /// No description provided for @animals.
  ///
  /// In ar, this message translates to:
  /// **'الحيوانات'**
  String get animals;

  /// No description provided for @fruitsAndVegetables.
  ///
  /// In ar, this message translates to:
  /// **'خضر و غلال'**
  String get fruitsAndVegetables;

  /// No description provided for @statsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الاحصائيات'**
  String get statsTitle;

  /// No description provided for @globalStatsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات العامة'**
  String get globalStatsTitle;

  /// No description provided for @categoryStatsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات حسب الفئة'**
  String get categoryStatsTitle;

  /// No description provided for @accuracy.
  ///
  /// In ar, this message translates to:
  /// **'معدل الاجابات الصحيحة'**
  String get accuracy;

  /// No description provided for @averageTime.
  ///
  /// In ar, this message translates to:
  /// **'متوسط الوقت'**
  String get averageTime;

  /// No description provided for @hintsUsed.
  ///
  /// In ar, this message translates to:
  /// **'التلميحات المستخدمة'**
  String get hintsUsed;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @periodThisWeek.
  ///
  /// In ar, this message translates to:
  /// **'هذا الأسبوع'**
  String get periodThisWeek;

  /// No description provided for @statsError.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إحصائيات متوفرة، حاول مرة أخرى لاحقا'**
  String get statsError;

  /// No description provided for @viewStats.
  ///
  /// In ar, this message translates to:
  /// **'الاطلاع على الاحصائيات'**
  String get viewStats;

  /// No description provided for @chooseCorrectColor.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللون الصحيح'**
  String get chooseCorrectColor;

  /// No description provided for @red.
  ///
  /// In ar, this message translates to:
  /// **'أحمر'**
  String get red;

  /// No description provided for @green.
  ///
  /// In ar, this message translates to:
  /// **'أخضر'**
  String get green;

  /// No description provided for @blue.
  ///
  /// In ar, this message translates to:
  /// **'أزرق'**
  String get blue;

  /// No description provided for @yellow.
  ///
  /// In ar, this message translates to:
  /// **'أصفر'**
  String get yellow;

  /// No description provided for @purple.
  ///
  /// In ar, this message translates to:
  /// **'بنفسجي'**
  String get purple;

  /// No description provided for @autism.
  ///
  /// In ar, this message translates to:
  /// **'التوحد'**
  String get autism;

  /// No description provided for @adhd.
  ///
  /// In ar, this message translates to:
  /// **'فرط الحركة ونقص الانتباه'**
  String get adhd;

  /// No description provided for @dyslexia.
  ///
  /// In ar, this message translates to:
  /// **'عسر القراءة'**
  String get dyslexia;

  /// No description provided for @dyscalculia.
  ///
  /// In ar, this message translates to:
  /// **'عسر الحساب'**
  String get dyscalculia;

  /// No description provided for @speakingDifficulties.
  ///
  /// In ar, this message translates to:
  /// **'صعوبات في النطق'**
  String get speakingDifficulties;

  /// No description provided for @unknownCategory.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get unknownCategory;

  /// No description provided for @unknownScreenType.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف نوع الشاشة'**
  String get unknownScreenType;

  /// No description provided for @applicationError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في التطبيق'**
  String get applicationError;

  /// رسالة خطأ عند فشل تحميل تفاصيل الألعاب.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الألعاب: {error}'**
  String errorLoadingGamesDetails(Object error);

  /// No description provided for @errorLoadingCategoryGamesDetails.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الألعاب للفئة {categoryName}: {error}'**
  String errorLoadingCategoryGamesDetails(String categoryName, Object error);

  /// No description provided for @errorLoadingProfileDetails.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل بيانات الملف الشخصي: {error}'**
  String errorLoadingProfileDetails(Object error);

  /// No description provided for @errorCheckingAuthDetails.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في التحقق من تسجيل الدخول: {error}'**
  String errorCheckingAuthDetails(Object error);

  /// No description provided for @noGameCategoriesAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فئات ألعاب متاحة.'**
  String get noGameCategoriesAvailable;

  /// No description provided for @noGamesInCategoryAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ألعاب متاحة في فئة {categoryName} حالياً.'**
  String noGamesInCategoryAvailable(String categoryName);

  /// No description provided for @authenticating.
  ///
  /// In ar, this message translates to:
  /// **'جاري المصادقة...'**
  String get authenticating;

  /// No description provided for @appFailedToInitialize.
  ///
  /// In ar, this message translates to:
  /// **'فشل تهيئة التطبيق: {error}'**
  String appFailedToInitialize(String error);

  /// No description provided for @featureNotImplemented.
  ///
  /// In ar, this message translates to:
  /// **'هذه الميزة لم تنفذ بعد.'**
  String get featureNotImplemented;

  /// No description provided for @errorCategoryMissing.
  ///
  /// In ar, this message translates to:
  /// **'خطأ: الفئة مفقودة.'**
  String get errorCategoryMissing;

  /// No description provided for @errorGameCategoryOrIdMissing.
  ///
  /// In ar, this message translates to:
  /// **'خطأ: فئة اللعبة أو المعرف مفقود.'**
  String get errorGameCategoryOrIdMissing;

  /// No description provided for @errorChildIdMissing.
  ///
  /// In ar, this message translates to:
  /// **'خطأ: معرف الطفل مفقود'**
  String get errorChildIdMissing;

  /// No description provided for @correct.
  ///
  /// In ar, this message translates to:
  /// **'صحيح!'**
  String get correct;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى!'**
  String get tryAgain;

  /// No description provided for @level.
  ///
  /// In ar, this message translates to:
  /// **'المستوى'**
  String get level;

  /// No description provided for @screen.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة'**
  String get screen;

  /// No description provided for @memoryGameUnderDevelopment.
  ///
  /// In ar, this message translates to:
  /// **'لعبة الذاكرة قيد التطوير'**
  String get memoryGameUnderDevelopment;

  /// No description provided for @goBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get goBack;

  /// No description provided for @selectableOption.
  ///
  /// In ar, this message translates to:
  /// **'خيار قابل للتحديد'**
  String get selectableOption;

  /// No description provided for @selected.
  ///
  /// In ar, this message translates to:
  /// **'تم التحديد'**
  String get selected;

  /// No description provided for @selectCorrectOption.
  ///
  /// In ar, this message translates to:
  /// **'حدد الخيار الصحيح'**
  String get selectCorrectOption;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signUp;

  /// No description provided for @enterEmail.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني'**
  String get enterEmail;

  /// No description provided for @validEmailError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال عنوان بريد إلكتروني صالح'**
  String get validEmailError;

  /// No description provided for @enterPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الخاصة بك'**
  String get enterPassword;

  /// No description provided for @passwordLengthError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال كلمة مرور تتكون من 6 أحرف على الأقل'**
  String get passwordLengthError;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'هل نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟ أنشئ حسابًا'**
  String get dontHaveAccount;

  /// No description provided for @haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك حساب بالفعل؟ تسجيل الدخول'**
  String get haveAccount;

  /// No description provided for @sendPasswordReset.
  ///
  /// In ar, this message translates to:
  /// **'إرسال بريد إعادة تعيين كلمة المرور'**
  String get sendPasswordReset;

  /// No description provided for @passwordResetSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال بريد إعادة تعيين كلمة المرور'**
  String get passwordResetSent;

  /// No description provided for @backToSignIn.
  ///
  /// In ar, this message translates to:
  /// **'العودة لتسجيل الدخول'**
  String get backToSignIn;

  /// No description provided for @unexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get unexpectedError;

  /// No description provided for @requiredFieldError.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get requiredFieldError;

  /// No description provided for @confirmPasswordError.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get confirmPasswordError;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @createChildProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء ملف تعريف الطفل'**
  String get createChildProfileTitle;

  /// No description provided for @selectAvatarPrompt.
  ///
  /// In ar, this message translates to:
  /// **'اختر صورة رمزية'**
  String get selectAvatarPrompt;

  /// No description provided for @firstNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول'**
  String get firstNameLabel;

  /// No description provided for @enterFirstNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الاسم الأول'**
  String get enterFirstNameHint;

  /// No description provided for @errorFirstNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال الاسم الأول'**
  String get errorFirstNameRequired;

  /// No description provided for @lastNameLabelOptional.
  ///
  /// In ar, this message translates to:
  /// **'اسم العائلة (اختياري)'**
  String get lastNameLabelOptional;

  /// No description provided for @enterLastNameHintOptional.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم العائلة (اختياري)'**
  String get enterLastNameHintOptional;

  /// No description provided for @birthdateLabelOptional.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد (اختياري)'**
  String get birthdateLabelOptional;

  /// No description provided for @selectDateButton.
  ///
  /// In ar, this message translates to:
  /// **'تحديد التاريخ'**
  String get selectDateButton;

  /// No description provided for @specialConditionsLabelOptional.
  ///
  /// In ar, this message translates to:
  /// **'الحالات الخاصة (اختياري)'**
  String get specialConditionsLabelOptional;

  /// No description provided for @createProfileButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الملف الشخصي'**
  String get createProfileButton;

  /// رسالة نجاح بعد إنشاء ملف تعريف الطفل.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الملف الشخصي لـ {firstName}!'**
  String profileCreatedSuccess(String firstName);

  /// No description provided for @errorCreatingProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إنشاء الملف الشخصي. الرجاء المحاولة مرة أخرى.'**
  String get errorCreatingProfile;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @errorScreenRestartInstruction.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إغلاق التطبيق وإعادة فتحه.'**
  String get errorScreenRestartInstruction;

  /// No description provided for @selectChildProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر الملف الشخصي'**
  String get selectChildProfileTitle;

  /// No description provided for @whoIsPlayingPrompt.
  ///
  /// In ar, this message translates to:
  /// **'من يلعب؟'**
  String get whoIsPlayingPrompt;

  /// No description provided for @addChildProfileButton.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملف تعريف طفل'**
  String get addChildProfileButton;

  /// No description provided for @manageProfilesTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الملفات الشخصية'**
  String get manageProfilesTooltip;

  /// No description provided for @switchChildProfileButton.
  ///
  /// In ar, this message translates to:
  /// **'تبديل الملف الشخصي'**
  String get switchChildProfileButton;

  /// No description provided for @onlyOneProfileExists.
  ///
  /// In ar, this message translates to:
  /// **'يوجد ملف شخصي واحد فقط.'**
  String get onlyOneProfileExists;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جار التحميل...'**
  String get loading;

  /// No description provided for @gameOver.
  ///
  /// In ar, this message translates to:
  /// **'انتهت اللعبة!'**
  String get gameOver;

  /// No description provided for @congratulationsAllLevelsComplete.
  ///
  /// In ar, this message translates to:
  /// **'تهانينا! لقد أكملت جميع المستويات!'**
  String get congratulationsAllLevelsComplete;

  /// No description provided for @playAgain.
  ///
  /// In ar, this message translates to:
  /// **'العب مرة أخرى'**
  String get playAgain;

  /// No description provided for @backToGames.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الألعاب'**
  String get backToGames;

  /// No description provided for @exitGameTooltip.
  ///
  /// In ar, this message translates to:
  /// **'الخروج من اللعبة'**
  String get exitGameTooltip;

  /// No description provided for @exitGameConfirmationTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخروج من اللعبة؟'**
  String get exitGameConfirmationTitle;

  /// No description provided for @exitGameConfirmationMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد الخروج؟ قد يتم فقدان تقدمك الحالي في هذا المستوى.'**
  String get exitGameConfirmationMessage;

  /// No description provided for @cancelButton.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancelButton;

  /// No description provided for @exitButton.
  ///
  /// In ar, this message translates to:
  /// **'خروج'**
  String get exitButton;

  /// No description provided for @repeatInstructionTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إعادة التعليمات'**
  String get repeatInstructionTooltip;

  /// No description provided for @onboardingDesc1.
  ///
  /// In ar, this message translates to:
  /// **'هذا التطبيق صُمم خصيصًا للأطفال ذوي الاحتياجات الخاصة. لنلعب ونتعلم معًا بطريقة ممتعة وآمنة.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingDesc2.
  ///
  /// In ar, this message translates to:
  /// **'تابعوا تقدم أطفالكم، واكتشفوا الأنشطة التي تنمي مهاراتهم بطريقة ذكية ومبسطة.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingSkipButton.
  ///
  /// In ar, this message translates to:
  /// **'تخطى'**
  String get onboardingSkipButton;

  /// No description provided for @onboardingGetStartedButton.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get onboardingGetStartedButton;

  /// No description provided for @loadingProfilesMessage.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الملفات الشخصية...'**
  String get loadingProfilesMessage;

  /// No description provided for @noProfilesFoundMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على ملفات شخصية...'**
  String get noProfilesFoundMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @ttsEnabledSetting.
  ///
  /// In ar, this message translates to:
  /// **'تمكين تحويل النص إلى كلام'**
  String get ttsEnabledSetting;

  /// No description provided for @soundEffectsEnabledSetting.
  ///
  /// In ar, this message translates to:
  /// **'تمكين المؤثرات الصوتية'**
  String get soundEffectsEnabledSetting;

  /// No description provided for @loadingSetting.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الإعداد...'**
  String get loadingSetting;

  /// No description provided for @errorLoadingSetting.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الإعداد'**
  String get errorLoadingSetting;

  /// No description provided for @languageSetting.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get languageSetting;

  /// No description provided for @selectLanguageDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة'**
  String get selectLanguageDialogTitle;

  /// No description provided for @ttsSpeechRateSetting.
  ///
  /// In ar, this message translates to:
  /// **'سرعة الكلام'**
  String get ttsSpeechRateSetting;

  /// No description provided for @ttsRateSlow.
  ///
  /// In ar, this message translates to:
  /// **'بطيء'**
  String get ttsRateSlow;

  /// No description provided for @ttsRateNormal.
  ///
  /// In ar, this message translates to:
  /// **'عادي'**
  String get ttsRateNormal;

  /// No description provided for @ttsRateFast.
  ///
  /// In ar, this message translates to:
  /// **'سريع'**
  String get ttsRateFast;

  /// No description provided for @hapticsEnabledSetting.
  ///
  /// In ar, this message translates to:
  /// **'تمكين ردود الفعل اللمسية'**
  String get hapticsEnabledSetting;

  /// No description provided for @settingsSectionAudio.
  ///
  /// In ar, this message translates to:
  /// **'الصوت والتعليقات'**
  String get settingsSectionAudio;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get settingsSectionGeneral;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In ar, this message translates to:
  /// **'عفواً! حدث خطأ ما.'**
  String get oopsSomethingWentWrong;

  /// No description provided for @retryButton.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get retryButton;

  /// No description provided for @closeAppButton.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق التطبيق'**
  String get closeAppButton;

  /// No description provided for @errorScreenContactSupport.
  ///
  /// In ar, this message translates to:
  /// **'إذا استمرت المشكلة، يرجى الاتصال بالدعم أو المحاولة مرة أخرى لاحقًا.'**
  String get errorScreenContactSupport;

  /// No description provided for @imageOption.
  ///
  /// In ar, this message translates to:
  /// **'خيار صورة'**
  String get imageOption;

  /// No description provided for @loadingUserData.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل بيانات المستخدم...'**
  String get loadingUserData;

  /// No description provided for @noGameCategoriesAvailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فئات ألعاب متاحة حالياً.'**
  String get noGameCategoriesAvailableMessage;

  /// No description provided for @loadingGamesFor.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الألعاب للفئة {categoryName}...'**
  String loadingGamesFor(String categoryName);

  /// No description provided for @allCategoriesFilter.
  ///
  /// In ar, this message translates to:
  /// **'جميع الفئات'**
  String get allCategoriesFilter;

  /// No description provided for @overallStatsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأداء العام'**
  String get overallStatsTitle;

  /// No description provided for @categoryAccuracyChartTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدقة حسب الفئة (كل الأوقات)'**
  String get categoryAccuracyChartTitle;

  /// No description provided for @noChartDataAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات كافية لعرض الرسم البياني.'**
  String get noChartDataAvailable;

  /// No description provided for @noStatsFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على إحصائيات للمرشحات المحددة.'**
  String get noStatsFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
