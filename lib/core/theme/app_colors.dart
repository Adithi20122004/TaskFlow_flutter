import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);       // Bold blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF0EA5E9);     // Sky
  static const Color tertiary = Color(0xFF8B5CF6);      // Violet accent

  // Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFE2E8F0);

  // Priority
  static const Color priorityHigh = Color(0xFFEF4444);       // Red
  static const Color priorityHighLight = Color(0xFFFEF2F2);
  static const Color priorityMedium = Color(0xFFF97316);     // Orange
  static const Color priorityMediumLight = Color(0xFFFFF7ED);
  static const Color priorityLow = Color(0xFF22C55E);        // Green
  static const Color priorityLowLight = Color(0xFFF0FDF4);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // Border
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF2563EB);

  // Completed task
  static const Color completedOverlay = Color(0x80FFFFFF);
  static const Color completedText = Color(0xFF94A3B8);

  // Dark theme
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF64748B);

  static ColorScheme get lightColorScheme => ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: textOnPrimary,
        primaryContainer: Color(0xFFDBEAFE),
        onPrimaryContainer: primaryDark,
        secondary: secondary,
        onSecondary: textOnPrimary,
        secondaryContainer: Color(0xFFE0F2FE),
        onSecondaryContainer: Color(0xFF0369A1),
        tertiary: tertiary,
        onTertiary: textOnPrimary,
        tertiaryContainer: Color(0xFFEDE9FE),
        onTertiaryContainer: Color(0xFF6D28D9),
        error: error,
        onError: textOnPrimary,
        errorContainer: errorLight,
        onErrorContainer: Color(0xFF991B1B),
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
        onPrimary: Color(0xFF1E3A8A),
        primaryContainer: primaryDark,
        onPrimaryContainer: Color(0xFFBFDBFE),
        secondary: secondary,
        onSecondary: Color(0xFF0C4A6E),
        secondaryContainer: Color(0xFF075985),
        onSecondaryContainer: Color(0xFFBAE6FD),
        tertiary: Color(0xFFA78BFA),
        onTertiary: Color(0xFF4C1D95),
        tertiaryContainer: Color(0xFF5B21B6),
        onTertiaryContainer: Color(0xFFEDE9FE),
        error: Color(0xFFF87171),
        onError: Color(0xFF7F1D1D),
        errorContainer: Color(0xFF991B1B),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: darkSurface,
        onSurface: darkTextPrimary,
        surfaceContainerHighest: darkSurfaceVariant,
        onSurfaceVariant: darkTextSecondary,
        outline: darkBorder,
        outlineVariant: Color(0xFF1E293B),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: surface,
        onInverseSurface: textPrimary,
        inversePrimary: primary,
      );
}