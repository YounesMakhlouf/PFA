import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5E9BAF);
  static const Color primaryLight = Color(0xFFB1D6E7);
  static const Color secondary = Color(0xFFFCCBA8);
  static const Color background = Color(0xFFE6F2F5);
  static const Color cardBackground = Color(0xFFB1D6E7);
  static const Color statBoxBackground = Color(0X99FFFFFF);
  static const Color lightGrey = Color(0xFFEEEEEE); // for buttons, borders...
  static const Color textPrimary = Color(0xFF000000);
  static const Color textLight = Colors.white;
  static const Color error = Color(0xFFBE2522);
  static const Color success = Color(0xFF3DC87D);
  static const Color warning = Color(0xFFDFEF35);
  static const Color disabled = Color(0xFFBBBBBB);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Sarabun',
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textLight,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textLight,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8.0),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 64,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Sarabun',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
