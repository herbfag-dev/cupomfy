import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        return const Right(null);
      }
      return Right(_mapSupabaseUser(currentUser));
    } catch (e, st) {
      AppLogger.error('getCurrentUser failed', e, st);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(Failure.unauthorized());
      }

      return Right(_mapSupabaseUser(response.user!));
    } on AuthException catch (e) {
      AppLogger.error('signInWithEmailAndPassword failed', e);
      return Left(Failure.unauthorized());
    } catch (e, st) {
      AppLogger.error('signInWithEmailAndPassword failed', e, st);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      if (response.user == null) {
        return const Left(Failure.server(message: 'Failed to create user'));
      }

      return Right(_mapSupabaseUser(response.user!));
    } on AuthException catch (e) {
      AppLogger.error('registerWithEmailAndPassword failed', e);
      return Left(Failure.validation(message: e.message));
    } catch (e, st) {
      AppLogger.error('registerWithEmailAndPassword failed', e, st);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('signOut failed', e, st);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return const Right(unit);
    } on AuthException catch (e) {
      AppLogger.error('sendPasswordResetEmail failed', e);
      return Left(Failure.validation(message: e.message));
    } catch (e, st) {
      AppLogger.error('sendPasswordResetEmail failed', e, st);
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? _mapSupabaseUser(user) : null;
    });
  }

  User _mapSupabaseUser(SupabaseUser supabaseUser) {
    return User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      displayName: supabaseUser.userMetadata?['display_name'] as String?,
      photoUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
      createdAt: DateTime.parse(supabaseUser.createdAt),
      updatedAt: DateTime.parse(supabaseUser.updatedAt ?? supabaseUser.createdAt),
    );
  }
}
