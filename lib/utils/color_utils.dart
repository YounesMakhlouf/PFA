import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';

extension HexColorParsing on String? {
  Color parseToColor({required Color fallbackColor}) {
    final hexCode = this;
    if (hexCode == null || hexCode.isEmpty) {
      return fallbackColor;
    }

    String formattedCode = hexCode.toUpperCase().replaceAll('#', '');
    if (formattedCode.length == 6) {
      formattedCode = 'FF$formattedCode';
    }

    if (formattedCode.length != 8) {
      return fallbackColor;
    }

    try {
      return Color(int.parse(formattedCode, radix: 16));
    } catch (e) {
      return fallbackColor;
    }
  }
}

Color getContrastingForegroundColor(Color backgroundColor) {
  // Determine foreground based on background luminance
  return backgroundColor.computeLuminance() > 0.5
      ? AppColors.textPrimary
      : AppColors.textLight;
}
