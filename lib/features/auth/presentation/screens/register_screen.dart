import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/constants/app_strings.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/snackbar_utils.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_event.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';
import 'package:gig_tasks/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthRegisterRequested(
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            SnackbarUtils.showSuccess(context, AppStrings.registerSuccess);
            context.go('/tasks');
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage =
              state is AuthFailureState ? state.message : null;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopSection(context),
                  _buildFormSection(context, isLoading, errorMessage),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.textOnPrimary,
              size: 44,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Let's get started!",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create an account to manage your tasks',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(
      BuildContext context, bool isLoading, String? errorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(errorMessage,
                          style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildFieldLabel('EMAIL ADDRESS'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: '',
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return AppStrings.emailRequired;
                }
                final regex = RegExp(
                    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
                if (!regex.hasMatch(v.trim())) return AppStrings.emailInvalid;
                return null;
              },
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('PASSWORD'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: '',
              hint: '••••••••',
              isPassword: true,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return AppStrings.passwordRequired;
                if (v.length < 6) return AppStrings.passwordTooShort;
                return null;
              },
              onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('CONFIRM PASSWORD'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              label: '',
              hint: '••••••••',
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: (v) {
                if (v == null || v.isEmpty) return AppStrings.passwordRequired;
                if (v != _passwordController.text) {
                  return AppStrings.passwordsDoNotMatch;
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textOnPrimary),
                      ),
                    )
                  : const Text('Sign up'),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.textTertiary,
      ),
    );
  }
}