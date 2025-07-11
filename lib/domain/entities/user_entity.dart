abstract class UserEntity {
  String get id;
  String get email;
  String? get displayName;
  String? get photoURL;
  DateTime? get createdAt;

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
  });
}
