import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app startup to check if a user session already exists.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired when the auth state stream emits a change.
final class AuthStateChanged extends AuthEvent {
  const AuthStateChanged();
}

/// Fired when the user submits the login form.
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Fired when the user submits the registration form.
final class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [email, password, confirmPassword];
}

/// Fired when the user taps the logout button.
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}