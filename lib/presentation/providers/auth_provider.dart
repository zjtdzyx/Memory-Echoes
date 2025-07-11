import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memory_echoes/domain/entities/user_entity.dart';
import 'package:memory_echoes/domain/usecases/auth_usecases.dart';
import 'package:memory_echoes/dependency_injection.dart';

part 'auth_provider.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required UserEntity user}) =
      _Authenticated;
  const factory AuthState.unauthenticated({String? message}) = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetAuthStatusUseCase _getAuthStatusUseCase;

  AuthNotifier(
    this._signInWithEmailUseCase,
    this._signUpWithEmailUseCase,
    this._signOutUseCase,
    this._getAuthStatusUseCase,
  ) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    _getAuthStatusUseCase().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _signInWithEmailUseCase(email, password);
      state = AuthState.authenticated(user: user);
    } catch (e) {
      state = AuthState.unauthenticated(message: e.toString());
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String displayName) async {
    state = const AuthState.loading();
    try {
      final user = await _signUpWithEmailUseCase(
          email: email, password: password, displayName: displayName);
      state = AuthState.authenticated(user: user);
    } catch (e) {
      state = AuthState.unauthenticated(message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    state = const AuthState.unauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(signInWithEmailUseCaseProvider),
    ref.watch(signUpWithEmailUseCaseProvider),
    ref.watch(signOutUseCaseProvider),
    ref.watch(getAuthStatusUseCaseProvider),
  );
});
