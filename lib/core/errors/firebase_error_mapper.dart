import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_tasks/core/errors/failures.dart';

class FirebaseErrorMapper {
  const FirebaseErrorMapper._();

  static AuthFailure fromAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthFailure('No account found with this email.');
      case 'wrong-password':
        return const AuthFailure('Incorrect password. Please try again.');
      case 'invalid-credential':
        return const AuthFailure('Invalid credentials. Check your email and password.');
      case 'email-already-in-use':
        return const AuthFailure('An account already exists with this email.');
      case 'weak-password':
        return const AuthFailure('Password must be at least 6 characters.');
      case 'invalid-email':
        return const AuthFailure('Please enter a valid email address.');
      case 'user-disabled':
        return const AuthFailure('This account has been disabled. Contact support.');
      case 'too-many-requests':
        return const AuthFailure('Too many attempts. Please try again later.');
      case 'operation-not-allowed':
        return const AuthFailure('Email/password sign-in is not enabled.');
      case 'network-request-failed':
        return const AuthFailure('Network error. Check your connection.');
      case 'requires-recent-login':
        return const AuthFailure('Please log in again to continue.');
      case 'account-exists-with-different-credential':
        return const AuthFailure('An account already exists with a different sign-in method.');
      default:
        return AuthFailure(e.message ?? 'Authentication failed. Please try again.');
    }
  }

  static Failure fromFirestoreException(Exception e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('permission-denied') || msg.contains('permission denied')) {
      return const PermissionFailure('You do not have permission to perform this action.');
    }
    if (msg.contains('not-found') || msg.contains('not found')) {
      return const NotFoundFailure('The requested resource was not found.');
    }
    if (msg.contains('unavailable') || msg.contains('network')) {
      return const NetworkFailure('Service unavailable. Check your connection.');
    }
    if (msg.contains('deadline-exceeded') || msg.contains('timeout')) {
      return const ServerFailure('Request timed out. Please try again.');
    }
    return UnknownFailure(e.toString());
  }
}