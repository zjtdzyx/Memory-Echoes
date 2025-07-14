import 'package:memory_echoes/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:memory_echoes/domain/entities/user_entity.dart';
import 'package:memory_echoes/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) {
    return _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<UserEntity> signInWithApple() {
    return _remoteDataSource.signInWithApple();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Future<UserEntity> signUpWithEmail(
      {required String email,
      required String password,
      required String displayName}) {
    return _remoteDataSource.signUpWithEmail(email, password, displayName);
  }

  @override
  Future<void> updateUser(UserEntity user) {
    return _remoteDataSource.updateUser(user);
  }
}
