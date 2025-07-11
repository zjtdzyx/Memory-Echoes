import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<UserEntity> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('邮箱和密码不能为空');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('请输入有效的邮箱地址');
    }

    return await _authRepository.signInWithEmailAndPassword(email, password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<UserEntity> call(String email, String password, String displayName) async {
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      throw Exception('所有字段都不能为空');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('请输入有效的邮箱地址');
    }

    if (password.length < 6) {
      throw Exception('密码长度至少为6位');
    }

    return await _authRepository.signUpWithEmailAndPassword(email, password, displayName);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<UserEntity?> call() async {
    return await _authRepository.getCurrentUser();
  }
}

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
