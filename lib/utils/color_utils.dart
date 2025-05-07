import 'package:flutter/material.dart';

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
