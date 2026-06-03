import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/core/utils/validation_utils.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    final emailError = ValidationUtils.validateEmail(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(emailError));
    }

    final passwordError = ValidationUtils.validatePassword(params.password);
    if (passwordError != null) {
      return Left(ValidationFailure(passwordError));
    }

    return _repository.login(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}