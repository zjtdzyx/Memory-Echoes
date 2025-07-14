import 'package:memory_echoes/domain/entities/user_entity.dart';
import 'package:memory_echoes/domain/repositories/auth_repository.dart';

class GetAuthStatusUseCase {
  final AuthRepository _repository;
  GetAuthStatusUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.authStateChanges;
  }
}

class SignInWithEmailUseCase {
  final AuthRepository _repository;
  SignInWithEmailUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }
}

class SignUpWithEmailUseCase {
  final AuthRepository _repository;
  SignUpWithEmailUseCase(this._repository);

  Future<UserEntity> call(
      {required String email,
      required String password,
      required String displayName}) {
    return _repository.signUpWithEmail(
        email: email, password: password, displayName: displayName);
  }
}

class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.signInWithGoogle();
  }
}

class SignInWithAppleUseCase {
  final AuthRepository _repository;
  SignInWithAppleUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.signInWithApple();
  }
}

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}

class UpdateUserUseCase {
  final AuthRepository _repository;
  UpdateUserUseCase(this._repository);

  Future<void> call(UserEntity user) {
    return _repository.updateUser(user);
  }
}
