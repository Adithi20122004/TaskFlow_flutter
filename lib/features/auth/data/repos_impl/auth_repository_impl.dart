import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/exceptions.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user?.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.register(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map(
      (model) => model?.toEntity(),
    );
  }
}