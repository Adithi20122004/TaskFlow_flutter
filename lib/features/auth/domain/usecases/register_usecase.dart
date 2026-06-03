import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/core/utils/validation_utils.dart';
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    final emailError = ValidationUtils.validateEmail(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(emailError));
    }

    final passwordError = ValidationUtils.validatePassword(params.password);
    if (passwordError != null) {
      return Left(ValidationFailure(passwordError));
    }

    final confirmError = ValidationUtils.validateConfirmPassword(
      params.confirmPassword,
      params.password,
    );
    if (confirmError != null) {
      return Left(ValidationFailure(confirmError));
    }

    return _repository.register(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [email, password, confirmPassword];
}