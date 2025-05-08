import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr() : super('ar');

  @override
  String get appTitle => 'تطبيق تعلم التوحد';

  // Home page
  @override
  String get learningGames => 'ألعاب التعلم';

  // Game categories
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

  //Stats
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
  // Game instructions
  @override
  String get chooseCorrectColor => 'اختر اللون الصحيح';

  // Colors
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

  // Special conditions
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

  // Error messages
  @override
  String get unknownCategory => 'أخرى';
  @override
  String get unknownScreenType => 'غير معروف نوع الشاشة';
  @override
  String get applicationError => 'خطأ في التطبيق';
  @override
  String get retry => 'إعادة المحاولة';
  @override
  String errorLoadingGamesDetails(Object error) =>
      'خطأ في تحميل الألعاب: $error';
  @override
  String errorLoadingCategoryGamesDetails(String categoryName, Object error) =>
      'خطأ في تحميل الألعاب للفئة $categoryName: $error';
  @override
  String errorLoadingProfileDetails(Object error) =>
      'خطأ في تحميل بيانات الملف الشخصي: $error';
  @override
  String errorCheckingAuthDetails(Object error) =>
      'خطأ في التحقق من المصادقة: $error';
  @override
  String get noGameCategoriesAvailable => 'لا توجد فئات ألعاب متاحة.';
  @override
  String noGamesInCategoryAvailable(String categoryName) =>
      'لا توجد ألعاب متاحة في فئة $categoryName حالياً.';

  // Game feedback
  @override
  String get correct => 'صحيح! 👏';
  @override
  String get tryAgain => 'حاول مرة أخرى! 🤔';

  // Game UI
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

// Authentication
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
  String profileCreatedSuccess(String firstName) =>
      '!$firstName تم إنشاء الملف الشخصي لـ';
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
  String get addChildProfileButton => 'إضافة ملف تعريف آخر';
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
}
