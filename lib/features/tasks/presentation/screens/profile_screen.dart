import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/constants/app_strings.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_event.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess || state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.profile)),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildAvatar(context, user),
                  const SizedBox(height: 20),
                  if (user != null) ...[
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.signedInAs,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildLogoutTile(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, UserEntity? user) {
    final initials = user?.initials ?? '?';
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: AppColors.error),
      title: Text(
        AppStrings.logout,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
      ),
      onTap: () => _confirmLogout(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.logoutConfirmTitle),
        content: const Text(AppStrings.logoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style:
                TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.logoutConfirmButton),
          ),
        ],
      ),
    );
  }
}