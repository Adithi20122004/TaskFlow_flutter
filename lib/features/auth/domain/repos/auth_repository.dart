import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Returns the currently signed-in user, or null if not authenticated.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Signs in with email and password.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Creates a new account with email and password.
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<Either<Failure, Unit>> logout();

  /// Stream that emits the current user whenever auth state changes.
  Stream<UserEntity?> get authStateChanges;
}