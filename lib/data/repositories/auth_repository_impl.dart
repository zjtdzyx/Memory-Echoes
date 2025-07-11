import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _authDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    final userModel = await _authDataSource.signInWithEmailAndPassword(email, password);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    final userModel = await _authDataSource.signUpWithEmailAndPassword(email, password, displayName);
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _authDataSource.resetPassword(email);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _authDataSource.authStateChanges.map((userModel) => userModel?.toEntity());
  }
}
