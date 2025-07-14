// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FavoriteEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get itemType =>
      throw _privateConstructorUsedError; // 'story' or 'biography'
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteEntityCopyWith<FavoriteEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteEntityCopyWith<$Res> {
  factory $FavoriteEntityCopyWith(
          FavoriteEntity value, $Res Function(FavoriteEntity) then) =
      _$FavoriteEntityCopyWithImpl<$Res, FavoriteEntity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String itemId,
      String itemType,
      DateTime createdAt,
      String? title,
      String? description,
      String? imageUrl});
}

/// @nodoc
class _$FavoriteEntityCopyWithImpl<$Res, $Val extends FavoriteEntity>
    implements $FavoriteEntityCopyWith<$Res> {
  _$FavoriteEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? itemType = null,
    Object? createdAt = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoriteEntityImplCopyWith<$Res>
    implements $FavoriteEntityCopyWith<$Res> {
  factory _$$FavoriteEntityImplCopyWith(_$FavoriteEntityImpl value,
          $Res Function(_$FavoriteEntityImpl) then) =
      __$$FavoriteEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String itemId,
      String itemType,
      DateTime createdAt,
      String? title,
      String? description,
      String? imageUrl});
}

/// @nodoc
class __$$FavoriteEntityImplCopyWithImpl<$Res>
    extends _$FavoriteEntityCopyWithImpl<$Res, _$FavoriteEntityImpl>
    implements _$$FavoriteEntityImplCopyWith<$Res> {
  __$$FavoriteEntityImplCopyWithImpl(
      _$FavoriteEntityImpl _value, $Res Function(_$FavoriteEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoriteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? itemType = null,
    Object? createdAt = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$FavoriteEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FavoriteEntityImpl implements _FavoriteEntity {
  const _$FavoriteEntityImpl(
      {required this.id,
      required this.userId,
      required this.itemId,
      required this.itemType,
      required this.createdAt,
      this.title,
      this.description,
      this.imageUrl});

  @override
  final String id;
  @override
  final String userId;
  @override
  final String itemId;
  @override
  final String itemType;
// 'story' or 'biography'
  @override
  final DateTime createdAt;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'FavoriteEntity(id: $id, userId: $userId, itemId: $itemId, itemType: $itemType, createdAt: $createdAt, title: $title, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, itemId, itemType,
      createdAt, title, description, imageUrl);

  /// Create a copy of FavoriteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteEntityImplCopyWith<_$FavoriteEntityImpl> get copyWith =>
      __$$FavoriteEntityImplCopyWithImpl<_$FavoriteEntityImpl>(
          this, _$identity);
}

abstract class _FavoriteEntity implements FavoriteEntity {
  const factory _FavoriteEntity(
      {required final String id,
      required final String userId,
      required final String itemId,
      required final String itemType,
      required final DateTime createdAt,
      final String? title,
      final String? description,
      final String? imageUrl}) = _$FavoriteEntityImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get itemId;
  @override
  String get itemType; // 'story' or 'biography'
  @override
  DateTime get createdAt;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get imageUrl;

  /// Create a copy of FavoriteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteEntityImplCopyWith<_$FavoriteEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
