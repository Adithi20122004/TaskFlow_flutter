import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/constants/app_strings.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/snackbar_utils.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_event.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';
import 'package:gig_tasks/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:gig_tasks/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:gig_tasks/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            SnackbarUtils.showSuccess(context, AppStrings.loginSuccess);
            context.go('/tasks');
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage =
              state is AuthFailureState ? state.message : null;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 56),
                    _buildHeader(context),
                    const SizedBox(height: 40),
                    if (errorMessage != null) ...[
                      AuthErrorBanner(message: errorMessage),
                      const SizedBox(height: 20),
                    ],
                    AuthTextField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      label: AppStrings.email,
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.email_outlined,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return AppStrings.emailRequired;
                        }
                        final regex = RegExp(
                            r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
                        if (!regex.hasMatch(v.trim())) {
                          return AppStrings.emailInvalid;
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      label: AppStrings.password,
                      hint: '••••••••',
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.passwordRequired;
                        }
                        if (v.length < 6) {
                          return AppStrings.passwordTooShort;
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 28),
                    AuthPrimaryButton(
                      label: AppStrings.login,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 24),
                    _buildRegisterLink(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: AppColors.textOnPrimary,
            size: 30,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.login,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.appTagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.noAccount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        GestureDetector(
          onTap: () => context.push('/register'),
          child: Text(
            AppStrings.signUp,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}