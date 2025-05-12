import 'package:flutter/cupertino.dart';
import '../l10n/app_localizations.dart';

String getLocalizedCategory(String key, BuildContext context) {
  final loc = AppLocalizations.of(context);
  switch (key) {
    case 'NUMBERS':
      return loc.numbers;
    case 'EDUCATION':
      return loc.education;
    case 'RELAXATION':
      return loc.relaxation;
    case 'COLORS_SHAPES':
      return loc.colorsAndShapes;
    case 'EMOTIONS':
      return loc.emotions;
    case 'LOGICAL_THINKING':
      return loc.logicalThinking;
    case 'ANIMALS':
      return loc.animals;
    case 'FRUITS_VEGETABLES':
      return loc.fruitsAndVegetables;
    default:
      return key;
  }
}