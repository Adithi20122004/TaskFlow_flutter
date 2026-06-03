import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextTheme get textTheme => GoogleFonts.interTextTheme(
        const TextTheme(
          // Display
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
            color: AppColors.textPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),

          // Headline
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),

          // Title
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            color: AppColors.textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: AppColors.textPrimary,
          ),

          // Body
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: AppColors.textPrimary,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: AppColors.textSecondary,
          ),

          // Label
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: AppColors.textPrimary,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.textTertiary,
          ),
        ),
      );
}