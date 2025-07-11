abstract class UserEntity {
  String get id;
  String get email;
  String? get displayName;
  String? get photoURL;
  bool get emailVerified;
  DateTime? get createdAt;
}
