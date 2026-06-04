import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Brand — purple/violet matching reference
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B85FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color primarySurface = Color(0xFFEEEDFF);

  // Surface
  static const Color background = Color(0xFFF8F8FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F3FB);
  static const Color surfaceContainer = Color(0xFFEAEAF5);

  // Priority
  static const Color priorityHigh = Color(0xFFFF5C5C);
  static const Color priorityHighLight = Color(0xFFFFEEEE);
  static const Color priorityMedium = Color(0xFFFF9F43);
  static const Color priorityMediumLight = Color(0xFFFFF3E8);
  static const Color priorityLow = Color(0xFF26C6A2);
  static const Color priorityLowLight = Color(0xFFE8FAF6);

  // Status
  static const Color success = Color(0xFF26C6A2);
  static const Color successLight = Color(0xFFE8FAF6);
  static const Color error = Color(0xFFFF5C5C);
  static const Color errorLight = Color(0xFFFFEEEE);
  static const Color warning = Color(0xFFFF9F43);
  static const Color warningLight = Color(0xFFFFF3E8);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B8A);
  static const Color textTertiary = Color(0xFFAAAAAC);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFCCCCDD);

  // Border
  static const Color border = Color(0xFFEAEAF5);
  static const Color borderFocused = Color(0xFF6C63FF);

  // Completed
  static const Color completedText = Color(0xFFAAAAAC);

  // Dark
  static const Color darkBackground = Color(0xFF12122A);
  static const Color darkSurface = Color(0xFF1E1E3A);
  static const Color darkSurfaceVariant = Color(0xFF2A2A4A);
  static const Color darkBorder = Color(0xFF2E2E50);
  static const Color darkTextPrimary = Color(0xFFF0F0FF);
  static const Color darkTextSecondary = Color(0xFFAAAAAC);
  static const Color darkTextTertiary = Color(0xFF6B6B8A);

  static ColorScheme get lightColorScheme => ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: textOnPrimary,
        primaryContainer: primarySurface,
        onPrimaryContainer: primaryDark,
        secondary: Color(0xFF26C6A2),
        onSecondary: textOnPrimary,
        secondaryContainer: successLight,
        onSecondaryContainer: Color(0xFF1A8A72),
        tertiary: Color(0xFFFF9F43),
        onTertiary: textOnPrimary,
        tertiaryContainer: warningLight,
        onTertiaryContainer: Color(0xFFCC7A2A),
        error: error,
        onError: textOnPrimary,
        errorContainer: errorLight,
        onErrorContainer: Color(0xFFCC3333),
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: textSecondary,
        outline: border,
        outlineVariant: surfaceContainer,
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: darkSurface,
        onInverseSurface: darkTextPrimary,
        inversePrimary: primaryLight,
      );

  static ColorScheme get darkColorScheme => ColorScheme(
        brightness: Brightness.dark,
        primary: primaryLight,
        onPrimary: Color(0xFF1A1A2E),
        primaryContainer: primaryDark,
        onPrimaryContainer: primarySurface,
        secondary: success,
        onSecondary: Color(0xFF1A1A2E),
        secondaryContainer: Color(0xFF1A5A4A),
        onSecondaryContainer: successLight,
        tertiary: warning,
        onTertiary: Color(0xFF1A1A2E),
        tertiaryContainer: Color(0xFF5A3A1A),
        onTertiaryContainer: warningLight,
        error: Color(0xFFFF8080),
        onError: Color(0xFF1A1A2E),
        errorContainer: Color(0xFF5A1A1A),
        onErrorContainer: errorLight,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        surfaceContainerHighest: darkSurfaceVariant,
        onSurfaceVariant: darkTextSecondary,
        outline: darkBorder,
        outlineVariant: Color(0xFF1E1E3A),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: surface,
        onInverseSurface: textPrimary,
        inversePrimary: primary,
      );
}