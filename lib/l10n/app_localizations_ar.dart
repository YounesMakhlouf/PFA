// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق تعلم التوحد';

  @override
  String get learningGames => 'ألعاب التعلم';

  @override
  String get logicalThinking => 'التفكير المنطقي';

  @override
  String get education => 'التعليم';

  @override
  String get relaxation => 'الاسترخاء';

  @override
  String get emotions => 'المشاعر';

  @override
  String get numbers => 'الأرقام';

  @override
  String get colorsAndShapes => 'ألوان وأشكال';

  @override
  String get animals => 'الحيوانات';

  @override
  String get fruitsAndVegetables => 'خضر و غلال';

  @override
  String get statsTitle => 'الاحصائيات';

  @override
  String get globalStatsTitle => 'الإحصائيات العامة';

  @override
  String get categoryStatsTitle => 'الإحصائيات حسب الفئة';

  @override
  String get accuracy => 'معدل الاجابات الصحيحة';

  @override
  String get averageTime => 'متوسط الوقت';

  @override
  String get hintsUsed => 'التلميحات المستخدمة';

  @override
  String get all => 'الكل';

  @override
  String get periodThisWeek => 'هذا الأسبوع';

  @override
  String get statsError => 'لا توجد إحصائيات متوفرة، حاول مرة أخرى لاحقا';

  @override
  String get viewStats => 'الاطلاع على الاحصائيات';

  @override
  String get chooseCorrectColor => 'اختر اللون الصحيح';

  @override
  String get red => 'أحمر';

  @override
  String get green => 'أخضر';

  @override
  String get blue => 'أزرق';

  @override
  String get yellow => 'أصفر';

  @override
  String get purple => 'بنفسجي';

  @override
  String get autism => 'التوحد';

  @override
  String get adhd => 'فرط الحركة ونقص الانتباه';

  @override
  String get dyslexia => 'عسر القراءة';

  @override
  String get dyscalculia => 'عسر الحساب';

  @override
  String get speakingDifficulties => 'صعوبات في النطق';

  @override
  String get unknownCategory => 'أخرى';

  @override
  String get unknownScreenType => 'غير معروف نوع الشاشة';

  @override
  String get applicationError => 'خطأ في التطبيق';

  @override
  String errorLoadingGamesDetails(Object error) {
    return 'خطأ في تحميل الألعاب: $error';
  }

  @override
  String errorLoadingCategoryGamesDetails(String categoryName, Object error) {
    return 'خطأ في تحميل الألعاب للفئة $categoryName: $error';
  }

  @override
  String errorLoadingProfileDetails(Object error) {
    return 'خطأ في تحميل بيانات الملف الشخصي: $error';
  }

  @override
  String errorCheckingAuthDetails(Object error) {
    return 'خطأ في التحقق من تسجيل الدخول: $error';
  }

  @override
  String get noGameCategoriesAvailable => 'لا توجد فئات ألعاب متاحة.';

  @override
  String noGamesInCategoryAvailable(String categoryName) {
    return 'لا توجد ألعاب متاحة في فئة $categoryName حالياً.';
  }

  @override
  String get authenticating => 'جاري المصادقة...';

  @override
  String appFailedToInitialize(String error) {
    return 'فشل تهيئة التطبيق: $error';
  }

  @override
  String get featureNotImplemented => 'هذه الميزة لم تنفذ بعد.';

  @override
  String get errorCategoryMissing => 'خطأ: الفئة مفقودة.';

  @override
  String get errorGameCategoryOrIdMissing => 'خطأ: فئة اللعبة أو المعرف مفقود.';

  @override
  String get errorChildIdMissing => 'خطأ: معرف الطفل مفقود';

  @override
  String get correct => 'صحيح!';

  @override
  String get tryAgain => 'حاول مرة أخرى!';

  @override
  String get level => 'المستوى';

  @override
  String get screen => 'الشاشة';

  @override
  String get memoryGameUnderDevelopment => 'لعبة الذاكرة قيد التطوير';

  @override
  String get goBack => 'رجوع';

  @override
  String get selectableOption => 'خيار قابل للتحديد';

  @override
  String get selected => 'تم التحديد';

  @override
  String get selectCorrectOption => 'حدد الخيار الصحيح';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get validEmailError => 'الرجاء إدخال عنوان بريد إلكتروني صالح';

  @override
  String get enterPassword => 'أدخل كلمة المرور الخاصة بك';

  @override
  String get passwordLengthError =>
      'الرجاء إدخال كلمة مرور تتكون من 6 أحرف على الأقل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ أنشئ حسابًا';

  @override
  String get haveAccount => 'هل لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get sendPasswordReset => 'إرسال بريد إعادة تعيين كلمة المرور';

  @override
  String get passwordResetSent => 'تم إرسال بريد إعادة تعيين كلمة المرور';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get requiredFieldError => 'هذا الحقل مطلوب';

  @override
  String get confirmPasswordError => 'كلمات المرور غير متطابقة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get createChildProfileTitle => 'إنشاء ملف تعريف الطفل';

  @override
  String get selectAvatarPrompt => 'اختر صورة رمزية';

  @override
  String get firstNameLabel => 'الاسم الأول';

  @override
  String get enterFirstNameHint => 'أدخل الاسم الأول';

  @override
  String get errorFirstNameRequired => 'الرجاء إدخال الاسم الأول';

  @override
  String get lastNameLabelOptional => 'اسم العائلة (اختياري)';

  @override
  String get enterLastNameHintOptional => 'أدخل اسم العائلة (اختياري)';

  @override
  String get birthdateLabelOptional => 'تاريخ الميلاد (اختياري)';

  @override
  String get selectDateButton => 'تحديد التاريخ';

  @override
  String get specialConditionsLabelOptional => 'الحالات الخاصة (اختياري)';

  @override
  String get createProfileButton => 'إنشاء الملف الشخصي';

  @override
  String profileCreatedSuccess(String firstName) {
    return 'تم إنشاء الملف الشخصي لـ $firstName!';
  }

  @override
  String get errorCreatingProfile =>
      'تعذر إنشاء الملف الشخصي. الرجاء المحاولة مرة أخرى.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get errorScreenRestartInstruction => 'يرجى إغلاق التطبيق وإعادة فتحه.';

  @override
  String get selectChildProfileTitle => 'اختر الملف الشخصي';

  @override
  String get whoIsPlayingPrompt => 'من يلعب؟';

  @override
  String get addChildProfileButton => 'إضافة ملف تعريف طفل';

  @override
  String get manageProfilesTooltip => 'إدارة الملفات الشخصية';

  @override
  String get switchChildProfileButton => 'تبديل الملف الشخصي';

  @override
  String get onlyOneProfileExists => 'يوجد ملف شخصي واحد فقط.';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get gameOver => 'انتهت اللعبة!';

  @override
  String get congratulationsAllLevelsComplete =>
      'تهانينا! لقد أكملت جميع المستويات!';

  @override
  String get playAgain => 'العب مرة أخرى';

  @override
  String get backToGames => 'العودة إلى الألعاب';

  @override
  String get exitGameTooltip => 'الخروج من اللعبة';

  @override
  String get exitGameConfirmationTitle => 'الخروج من اللعبة؟';

  @override
  String get exitGameConfirmationMessage =>
      'هل أنت متأكد أنك تريد الخروج؟ قد يتم فقدان تقدمك الحالي في هذا المستوى.';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get exitButton => 'خروج';

  @override
  String get repeatInstructionTooltip => 'إعادة التعليمات';

  @override
  String get onboardingDesc1 =>
      'هذا التطبيق صُمم خصيصًا للأطفال ذوي الاحتياجات الخاصة. لنلعب ونتعلم معًا بطريقة ممتعة وآمنة.';

  @override
  String get onboardingDesc2 =>
      'تابعوا تقدم أطفالكم، واكتشفوا الأنشطة التي تنمي مهاراتهم بطريقة ذكية ومبسطة.';

  @override
  String get onboardingSkipButton => 'تخطى';

  @override
  String get onboardingGetStartedButton => 'ابدأ الآن';

  @override
  String get loadingProfilesMessage => 'جاري تحميل الملفات الشخصية...';

  @override
  String get noProfilesFoundMessage => 'لم يتم العثور على ملفات شخصية...';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get ttsEnabledSetting => 'تمكين تحويل النص إلى كلام';

  @override
  String get soundEffectsEnabledSetting => 'تمكين المؤثرات الصوتية';

  @override
  String get loadingSetting => 'جاري تحميل الإعداد...';

  @override
  String get errorLoadingSetting => 'خطأ في تحميل الإعداد';

  @override
  String get languageSetting => 'اللغة';

  @override
  String get selectLanguageDialogTitle => 'اختر اللغة';

  @override
  String get ttsSpeechRateSetting => 'سرعة الكلام';

  @override
  String get ttsRateSlow => 'بطيء';

  @override
  String get ttsRateNormal => 'عادي';

  @override
  String get ttsRateFast => 'سريع';

  @override
  String get hapticsEnabledSetting => 'تمكين ردود الفعل اللمسية';

  @override
  String get settingsSectionAudio => 'الصوت والتعليقات';

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get oopsSomethingWentWrong => 'عفواً! حدث خطأ ما.';

  @override
  String get retryButton => 'حاول مرة أخرى';

  @override
  String get closeAppButton => 'إغلاق التطبيق';

  @override
  String get errorScreenContactSupport =>
      'إذا استمرت المشكلة، يرجى الاتصال بالدعم أو المحاولة مرة أخرى لاحقًا.';

  @override
  String get imageOption => 'خيار صورة';

  @override
  String get loadingUserData => 'جاري تحميل بيانات المستخدم...';

  @override
  String get noGameCategoriesAvailableMessage =>
      'لا توجد فئات ألعاب متاحة حالياً.';

  @override
  String loadingGamesFor(String categoryName) {
    return 'جاري تحميل الألعاب للفئة $categoryName...';
  }

  @override
  String get allCategoriesFilter => 'جميع الفئات';

  @override
  String get overallStatsTitle => 'الأداء العام';

  @override
  String get categoryAccuracyChartTitle => 'الدقة حسب الفئة (كل الأوقات)';

  @override
  String get noChartDataAvailable => 'لا توجد بيانات كافية لعرض الرسم البياني.';

  @override
  String get noStatsFound => 'لم يتم العثور على إحصائيات للمرشحات المحددة.';
}
