// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedbackEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'bug', 'feature', 'general'
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackEntityCopyWith<FeedbackEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackEntityCopyWith<$Res> {
  factory $FeedbackEntityCopyWith(
          FeedbackEntity value, $Res Function(FeedbackEntity) then) =
      _$FeedbackEntityCopyWithImpl<$Res, FeedbackEntity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      String title,
      String content,
      DateTime createdAt,
      String? email,
      String? status});
}

/// @nodoc
class _$FeedbackEntityCopyWithImpl<$Res, $Val extends FeedbackEntity>
    implements $FeedbackEntityCopyWith<$Res> {
  _$FeedbackEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? email = freezed,
    Object? status = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedbackEntityImplCopyWith<$Res>
    implements $FeedbackEntityCopyWith<$Res> {
  factory _$$FeedbackEntityImplCopyWith(_$FeedbackEntityImpl value,
          $Res Function(_$FeedbackEntityImpl) then) =
      __$$FeedbackEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      String title,
      String content,
      DateTime createdAt,
      String? email,
      String? status});
}

/// @nodoc
class __$$FeedbackEntityImplCopyWithImpl<$Res>
    extends _$FeedbackEntityCopyWithImpl<$Res, _$FeedbackEntityImpl>
    implements _$$FeedbackEntityImplCopyWith<$Res> {
  __$$FeedbackEntityImplCopyWithImpl(
      _$FeedbackEntityImpl _value, $Res Function(_$FeedbackEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? email = freezed,
    Object? status = freezed,
  }) {
    return _then(_$FeedbackEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FeedbackEntityImpl implements _FeedbackEntity {
  const _$FeedbackEntityImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.content,
      required this.createdAt,
      this.email,
      this.status});

  @override
  final String id;
  @override
  final String userId;
  @override
  final String type;
// 'bug', 'feature', 'general'
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final String? email;
  @override
  final String? status;

  @override
  String toString() {
    return 'FeedbackEntity(id: $id, userId: $userId, type: $type, title: $title, content: $content, createdAt: $createdAt, email: $email, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, type, title, content, createdAt, email, status);

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackEntityImplCopyWith<_$FeedbackEntityImpl> get copyWith =>
      __$$FeedbackEntityImplCopyWithImpl<_$FeedbackEntityImpl>(
          this, _$identity);
}

abstract class _FeedbackEntity implements FeedbackEntity {
  const factory _FeedbackEntity(
      {required final String id,
      required final String userId,
      required final String type,
      required final String title,
      required final String content,
      required final DateTime createdAt,
      final String? email,
      final String? status}) = _$FeedbackEntityImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get type; // 'bug', 'feature', 'general'
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  String? get email;
  @override
  String? get status;

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackEntityImplCopyWith<_$FeedbackEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
