import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';

class AuthStateChangesUseCase {
  final AuthRepository _repository;

  const AuthStateChangesUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.authStateChanges;
  }
}