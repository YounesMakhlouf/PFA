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
  String get unknownScreenType => 'غير معروف نوع الشاشة';
}
