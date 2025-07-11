import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../dependency_injection.dart';

// 认证状态
abstract class AuthState {}

class Initial extends AuthState {}

class Loading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// 认证状态通知器
class AuthStateNotifier extends StateNotifier<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthStateNotifier(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
  ) : super(Initial()) {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = Unauthenticated();
      }
    } catch (e) {
      state = Unauthenticated();
    }
  }

  Future<void> signIn(String email, String password) async {
    state = Loading();
    try {
      final user = await _signInUseCase(email, password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    state = Loading();
    try {
      final user = await _signUpUseCase(email, password, displayName);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _signOutUseCase();
      state = Unauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}

// 提供者
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    ref.read(signInUseCaseProvider),
    ref.read(signUpUseCaseProvider),
    ref.read(signOutUseCaseProvider),
    ref.read(getCurrentUserUseCaseProvider),
  );
});
