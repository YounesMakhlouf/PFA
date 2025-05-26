import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5E9BAF);
  static const Color primaryLight = Color(0xFFB1D6E7);
  static const Color secondary = Color(0xFFFCCBA8);
  static const Color tertiary = Color(0xFFE0A07E);
  static const Color background = Color(0xFFE6F2F5);
  static const Color surface = Color(0xFFE6F2F5);
  static const Color surfaceVariant = Color(0xFFDCE4E8);
  static const Color outline = Color(0xFFC4C7C5); // Borders, dividers

  // Text Colors
  static const Color textPrimaryOnLight = Color(0xFF1F2937);
  static const Color textSecondaryOnLight = Color(0xFF4B5563);
  static const Color textPrimaryOnDark = Colors.white;
  static const Color textSecondaryOnDark = Color(0xFFE5E7EB);

  // Semantic Colors
  static const Color error = Color(0xFFBE2522);
  static const Color onError = Colors.white;
  static const Color success = Color(0xFF3DC87D);
  static const Color onSuccess = Colors.white;
  static const Color warning = Color(0xFFFFC107);
  static const Color onWarning = Colors.black;

  static const Color disabled = Color(0xFFBBBBBB);
  static const Color onDisabled = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    const String defaultFontFamily = 'Sarabun';
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimaryOnDark,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textPrimaryOnLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimaryOnLight,
      secondaryContainer: AppColors.secondary.withValues(alpha: 0.2),
      onSecondaryContainer: AppColors.textPrimaryOnLight,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.textPrimaryOnDark,
      tertiaryContainer: AppColors.tertiary.withValues(alpha: 0.2),
      onTertiaryContainer: AppColors.textPrimaryOnLight,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.error.withValues(alpha: 0.15),
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimaryOnLight,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondaryOnLight,
      outline: AppColors.outline,
      outlineVariant: AppColors.outline.withValues(alpha: 0.5),
      shadow: Colors.black.withValues(alpha: 0.1),
      brightness: Brightness.light,
    );
    final textTheme = base.textTheme
        .copyWith(
          displayLarge: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 57,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface),
          displayMedium: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 45,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface),
          displaySmall: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface),
          headlineLarge: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface),
          headlineMedium: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface),
          headlineSmall: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface),
          titleLarge: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface),
          titleMedium: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              color: colorScheme.onSurface),
          titleSmall: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: colorScheme.onSurface),
          bodyLarge: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: colorScheme.onSurface),
          bodyMedium: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              color: colorScheme.onSurfaceVariant),
          bodySmall: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
              color: colorScheme.onSurfaceVariant),
          labelLarge: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              color: colorScheme.primary),
          labelMedium: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: colorScheme.onSurfaceVariant),
          labelSmall: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: colorScheme.onSurfaceVariant),
        )
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
          decorationColor: colorScheme.primary,
        );

    return base.copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      colorScheme: colorScheme,
      textTheme: textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0.5,
        scrolledUnderElevation: 2.0,
        iconTheme: IconThemeData(color: colorScheme.primary),
        actionsIconTheme: IconThemeData(color: colorScheme.primary),
        titleTextStyle:
            textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary),
        elevation: 2,
        shadowColor: colorScheme.shadow,
      )),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: textTheme.labelLarge,
      )),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        labelStyle:
            textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        floatingLabelStyle:
            textTheme.bodySmall?.copyWith(color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: colorScheme.outline.withValues(alpha: 0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.3),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.2),
        valueIndicatorColor: colorScheme.secondary,
        valueIndicatorTextStyle:
            textTheme.bodySmall?.copyWith(color: colorScheme.onSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        disabledColor: AppColors.disabled.withValues(alpha: 0.1),
        selectedColor: colorScheme.primary,
        secondarySelectedColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: textTheme.labelMedium
            ?.copyWith(color: colorScheme.onSecondaryContainer),
        secondaryLabelStyle:
            textTheme.labelMedium?.copyWith(color: colorScheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle:
            textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        tileColor: colorScheme.surface,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24.0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
    );
  }
}
