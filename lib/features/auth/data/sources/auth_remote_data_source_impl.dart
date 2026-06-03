import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_tasks/core/errors/exceptions.dart';
import 'package:gig_tasks/core/errors/firebase_error_mapper.dart';
import 'package:gig_tasks/features/auth/data/models/user_model.dart';
import 'package:gig_tasks/features/auth/data/sources/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  const AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Login succeeded but no user was returned.');
      }
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        FirebaseErrorMapper.fromAuthException(e).message,
      );
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
            'Registration succeeded but no user was returned.');
      }
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        FirebaseErrorMapper.fromAuthException(e).message,
      );
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        FirebaseErrorMapper.fromAuthException(e).message,
      );
    } catch (e) {
      throw AuthException('An unexpected error occurred during logout: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw AuthException('Could not retrieve current user: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }
}