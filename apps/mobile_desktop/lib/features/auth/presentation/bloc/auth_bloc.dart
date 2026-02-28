import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Listen to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthEvent.authStateChanged(isAuthenticated: user != null));
    });
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user: user));
        } else {
          emit(const AuthState.unauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthState.error(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.registerWithEmailAndPassword(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );

    result.fold(
      (failure) => emit(AuthState.error(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthState.error(message: _mapFailureToMessage(failure))),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.sendPasswordResetEmail(
      email: event.email,
    );

    result.fold(
      (failure) => emit(AuthState.error(message: _mapFailureToMessage(failure))),
      (_) => emit(const AuthState.passwordResetSent()),
    );
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    // This is handled by the individual events, but we could use it
    // for global auth state updates if needed
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      server: (message) => message ?? 'Server error occurred',
      cache: (message) => message ?? 'Cache error occurred',
      network: () => 'Network error. Please check your connection',
      notFound: (message) => message ?? 'Resource not found',
      unauthorized: () => 'Invalid email or password',
      forbidden: () => 'Access forbidden',
      validation: (message) => message ?? 'Invalid input',
      unknown: (message) => message ?? 'An unexpected error occurred',
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
