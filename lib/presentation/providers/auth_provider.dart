import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../dependency_injection.dart';
import 'auth_state.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(signInWithEmailUseCaseProvider),
    ref.read(signUpWithEmailUseCaseProvider),
    ref.read(signOutUseCaseProvider),
    ref.read(getAuthStatusUseCaseProvider),
  );
});

@Deprecated('Use authStateProvider instead')
final authProvider = authStateProvider;

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
  ) : super(const AuthState.loading()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    _getAuthStatusUseCase().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _signInWithEmailUseCase(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String displayName) async {
    state = const AuthState.loading();
    try {
      final user = await _signUpWithEmailUseCase(
          email: email, password: password, displayName: displayName);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    state = const AuthState.unauthenticated();
  }

  void setAuthenticated(UserEntity user) {
    state = AuthState.authenticated(user);
  }

  void setUnauthenticated() {
    state = const AuthState.unauthenticated();
  }
}
