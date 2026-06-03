import 'package:gig_tasks/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}