import 'package:equatable/equatable.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any auth check has run.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Auth check or operation is in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// A user is authenticated and ready to use the app.
final class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// No user is authenticated — show login/register.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Login succeeded — used to trigger navigation and snackbar.
final class AuthLoginSuccess extends AuthState {
  final UserEntity user;

  const AuthLoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

/// Registration succeeded — used to trigger navigation and snackbar.
final class AuthRegisterSuccess extends AuthState {
  final UserEntity user;

  const AuthRegisterSuccess(this.user);

  @override
  List<Object> get props => [user];
}

/// Logout succeeded.
final class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}

/// An auth operation failed.
final class AuthFailureState extends AuthState {
  final String message;

  const AuthFailureState(this.message);

  @override
  List<Object> get props => [message];
}