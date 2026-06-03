import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() async {
    return _repository.logout();
  }
}