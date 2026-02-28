import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Get the current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Register with email and password
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out
  Future<Either<Failure, Unit>> signOut();

  /// Send password reset email
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  /// Stream of auth state changes
  Stream<User?> get authStateChanges;
}
