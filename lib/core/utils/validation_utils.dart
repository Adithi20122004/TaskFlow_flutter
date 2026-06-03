import 'package:gig_tasks/core/constants/app_constants.dart';
import 'package:gig_tasks/core/constants/app_strings.dart';

class ValidationUtils {
  const ValidationUtils._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < AppConstants.passwordMinLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.titleRequired;
    }
    if (value.trim().length > AppConstants.taskTitleMaxLength) {
      return AppStrings.titleTooLong;
    }
    return null;
  }

  static String? validateTaskDescription(String? value) {
    if (value != null &&
        value.trim().length > AppConstants.taskDescriptionMaxLength) {
      return AppStrings.descriptionTooLong;
    }
    return null;
  }

  static String? validateDueDate(DateTime? value) {
    if (value == null) {
      return AppStrings.dueDateRequired;
    }
    return null;
  }
}