import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_tasks/features/auth/domain/usecases/auth_state_changes_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/login_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/register_usecase.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_event.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthStateChangesUseCase _authStateChangesUseCase;

  StreamSubscription<dynamic>? _authStateSubscription;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthStateChangesUseCase authStateChangesUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authStateChangesUseCase = authStateChangesUseCase,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Subscribe to Firebase auth state stream immediately.
    _authStateSubscription = _authStateChangesUseCase().listen(
      (user) => add(const AuthStateChanged()),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          // Only emit AuthAuthenticated if we're not in a success state
          // (to avoid overwriting AuthLoginSuccess before UI can react).
          if (state is! AuthLoginSuccess && state is! AuthRegisterSuccess) {
            emit(AuthAuthenticated(user));
          }
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthLoginSuccess(user)),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthRegisterSuccess(user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(const AuthLogoutSuccess()),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}