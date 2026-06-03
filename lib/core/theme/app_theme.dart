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

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        foregroundColor:
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.border,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.textTheme.titleLarge?.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textTertiary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.textTheme.labelLarge,
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderFocused,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        labelStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTextStyles.textTheme.bodySmall?.copyWith(
          color: AppColors.error,
        ),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        labelStyle: AppTextStyles.textTheme.labelMedium,
        secondaryLabelStyle: AppTextStyles.textTheme.labelMedium?.copyWith(
          color: AppColors.textOnPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        thickness: 1,
        space: 0,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurfaceVariant : AppColors.textPrimary,
        contentTextStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        titleTextStyle: AppTextStyles.textTheme.titleLarge,
        contentTextStyle: AppTextStyles.textTheme.bodyMedium,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        titleTextStyle: AppTextStyles.textTheme.bodyLarge,
        subtitleTextStyle: AppTextStyles.textTheme.bodySmall,
      ),

      // Icon
      iconTheme: IconThemeData(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        size: 24,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return isDark ? AppColors.darkTextSecondary : AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return isDark ? AppColors.darkSurfaceVariant : AppColors.border;
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.5,
        ),
      ),

      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
      ),
    );
  }
}