import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_echoes/data/models/user_model.dart';
import 'package:memory_echoes/domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource(this._firebaseAuth, this._firestore);

  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign in failed: user not found.');
      }
      // You might want to fetch full user profile from Firestore here
      return _userFromFirebase(user)!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserEntity> signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'photoURL': null,
        });
      }
      return _userFromFirebase(user)!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  UserEntity? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  // This should probably be in a separate user datasource, but keeping here for simplicity
  Future<void> updateUser(UserEntity user) async {
    await _firestore.collection('users').doc(user.id).update({
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    });
  }
}
