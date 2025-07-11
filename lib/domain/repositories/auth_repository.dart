import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password, String displayName);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<UserEntity?> get authStateChanges;
}
