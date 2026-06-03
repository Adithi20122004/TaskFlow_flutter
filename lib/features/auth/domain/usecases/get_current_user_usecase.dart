import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return _repository.getCurrentUser();
  }
}