import 'package:memory_echoes/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(
      {required String email,
      required String password,
      required String displayName});
  Future<void> signOut();
  Future<void> updateUser(UserEntity user);
}
