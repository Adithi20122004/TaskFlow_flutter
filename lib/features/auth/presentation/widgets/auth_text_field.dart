import 'package:flutter/material.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final IconData? prefixIcon;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.prefixIcon,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // ✅ THIS is the fix — text color is now set correctly
      style: TextStyle(
        color: isDark ? Colors.white : AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textTertiary,
                ),
                onPressed: () =>
                    setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
    );
  }
}