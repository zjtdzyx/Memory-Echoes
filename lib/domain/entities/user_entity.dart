class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}
