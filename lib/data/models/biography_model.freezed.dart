// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biography_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BiographyModel _$BiographyModelFromJson(Map<String, dynamic> json) {
  return _BiographyModel.fromJson(json);
}

/// @nodoc
mixin _$BiographyModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get storyIds => throw _privateConstructorUsedError;
  String get coverImageUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  BiographyTheme get theme => throw _privateConstructorUsedError;

  /// Serializes this BiographyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BiographyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BiographyModelCopyWith<BiographyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiographyModelCopyWith<$Res> {
  factory $BiographyModelCopyWith(
          BiographyModel value, $Res Function(BiographyModel) then) =
      _$BiographyModelCopyWithImpl<$Res, BiographyModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String content,
      List<String> storyIds,
      String coverImageUrl,
      DateTime createdAt,
      DateTime updatedAt,
      bool isPublic,
      BiographyTheme theme});
}

/// @nodoc
class _$BiographyModelCopyWithImpl<$Res, $Val extends BiographyModel>
    implements $BiographyModelCopyWith<$Res> {
  _$BiographyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BiographyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? content = null,
    Object? storyIds = null,
    Object? coverImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isPublic = null,
    Object? theme = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      storyIds: null == storyIds
          ? _value.storyIds
          : storyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverImageUrl: null == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as BiographyTheme,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiographyModelImplCopyWith<$Res>
    implements $BiographyModelCopyWith<$Res> {
  factory _$$BiographyModelImplCopyWith(_$BiographyModelImpl value,
          $Res Function(_$BiographyModelImpl) then) =
      __$$BiographyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String content,
      List<String> storyIds,
      String coverImageUrl,
      DateTime createdAt,
      DateTime updatedAt,
      bool isPublic,
      BiographyTheme theme});
}

/// @nodoc
class __$$BiographyModelImplCopyWithImpl<$Res>
    extends _$BiographyModelCopyWithImpl<$Res, _$BiographyModelImpl>
    implements _$$BiographyModelImplCopyWith<$Res> {
  __$$BiographyModelImplCopyWithImpl(
      _$BiographyModelImpl _value, $Res Function(_$BiographyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiographyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? content = null,
    Object? storyIds = null,
    Object? coverImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isPublic = null,
    Object? theme = null,
  }) {
    return _then(_$BiographyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      storyIds: null == storyIds
          ? _value._storyIds
          : storyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverImageUrl: null == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as BiographyTheme,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BiographyModelImpl implements _BiographyModel {
  const _$BiographyModelImpl(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content,
      final List<String> storyIds = const [],
      this.coverImageUrl = '',
      required this.createdAt,
      required this.updatedAt,
      this.isPublic = false,
      this.theme = BiographyTheme.classic})
      : _storyIds = storyIds;

  factory _$BiographyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BiographyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String content;
  final List<String> _storyIds;
  @override
  @JsonKey()
  List<String> get storyIds {
    if (_storyIds is EqualUnmodifiableListView) return _storyIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_storyIds);
  }

  @override
  @JsonKey()
  final String coverImageUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final BiographyTheme theme;

  @override
  String toString() {
    return 'BiographyModel(id: $id, userId: $userId, title: $title, content: $content, storyIds: $storyIds, coverImageUrl: $coverImageUrl, createdAt: $createdAt, updatedAt: $updatedAt, isPublic: $isPublic, theme: $theme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiographyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._storyIds, _storyIds) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.theme, theme) || other.theme == theme));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      content,
      const DeepCollectionEquality().hash(_storyIds),
      coverImageUrl,
      createdAt,
      updatedAt,
      isPublic,
      theme);

  /// Create a copy of BiographyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiographyModelImplCopyWith<_$BiographyModelImpl> get copyWith =>
      __$$BiographyModelImplCopyWithImpl<_$BiographyModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BiographyModelImplToJson(
      this,
    );
  }
}

abstract class _BiographyModel implements BiographyModel {
  const factory _BiographyModel(
      {required final String id,
      required final String userId,
      required final String title,
      required final String content,
      final List<String> storyIds,
      final String coverImageUrl,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isPublic,
      final BiographyTheme theme}) = _$BiographyModelImpl;

  factory _BiographyModel.fromJson(Map<String, dynamic> json) =
      _$BiographyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get storyIds;
  @override
  String get coverImageUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isPublic;
  @override
  BiographyTheme get theme;

  /// Create a copy of BiographyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiographyModelImplCopyWith<_$BiographyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
