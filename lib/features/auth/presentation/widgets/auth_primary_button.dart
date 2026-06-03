import 'package:flutter/material.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
              ),
            )
          : Text(label),
    );
  }
}