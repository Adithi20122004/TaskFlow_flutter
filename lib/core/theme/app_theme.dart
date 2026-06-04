import 'package:flutter/material.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(
        colorScheme: AppColors.lightColorScheme,
        brightness: Brightness.light,
      );

  static ThemeData get dark => _buildTheme(
        colorScheme: AppColors.darkColorScheme,
        brightness: Brightness.dark,
      );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextStyles.textTheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor:
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.textTheme.titleLarge?.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textTertiary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: AppTextStyles.textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.borderFocused,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTextStyles.textTheme.bodySmall?.copyWith(
          color: AppColors.error,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        labelStyle: AppTextStyles.textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        thickness: 1,
        space: 0,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.textPrimary,
        contentTextStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        elevation: 0,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        titleTextStyle: AppTextStyles.textTheme.titleLarge,
        contentTextStyle: AppTextStyles.textTheme.bodyMedium,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}