import 'package:flutter/material.dart';
import 'package:gig_tasks/core/constants/app_constants.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';

enum SnackbarType { success, error, info, warning }

class SnackbarUtils {
  const SnackbarUtils._();

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    final (backgroundColor, icon) = switch (type) {
      SnackbarType.success => (AppColors.success, Icons.check_circle_outline_rounded),
      SnackbarType.error   => (AppColors.error, Icons.error_outline_rounded),
      SnackbarType.warning => (AppColors.warning, Icons.warning_amber_rounded),
      SnackbarType.info    => (AppColors.textPrimary, Icons.info_outline_rounded),
    };

    messenger.showSnackBar(
      SnackBar(
        duration: Duration(seconds: AppConstants.snackbarDurationSeconds),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            Icon(icon, color: AppColors.textOnPrimary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.textOnPrimary,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.success);

  static void showError(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.error);

  static void showInfo(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.info);

  static void showWarning(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.warning);
}