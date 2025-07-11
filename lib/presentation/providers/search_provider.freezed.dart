// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchState {
  String get query => throw _privateConstructorUsedError;
  List<StoryEntity> get results => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  StoryMood? get moodFilter => throw _privateConstructorUsedError;
  String? get tagFilter => throw _privateConstructorUsedError;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res, SearchState>;
  @useResult
  $Res call(
      {String query,
      List<StoryEntity> results,
      bool isLoading,
      String? error,
      StoryMood? moodFilter,
      String? tagFilter});
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? results = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? moodFilter = freezed,
    Object? tagFilter = freezed,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<StoryEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      moodFilter: freezed == moodFilter
          ? _value.moodFilter
          : moodFilter // ignore: cast_nullable_to_non_nullable
              as StoryMood?,
      tagFilter: freezed == tagFilter
          ? _value.tagFilter
          : tagFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchStateImplCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$SearchStateImplCopyWith(
          _$SearchStateImpl value, $Res Function(_$SearchStateImpl) then) =
      __$$SearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      List<StoryEntity> results,
      bool isLoading,
      String? error,
      StoryMood? moodFilter,
      String? tagFilter});
}

/// @nodoc
class __$$SearchStateImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateImpl>
    implements _$$SearchStateImplCopyWith<$Res> {
  __$$SearchStateImplCopyWithImpl(
      _$SearchStateImpl _value, $Res Function(_$SearchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? results = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? moodFilter = freezed,
    Object? tagFilter = freezed,
  }) {
    return _then(_$SearchStateImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<StoryEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      moodFilter: freezed == moodFilter
          ? _value.moodFilter
          : moodFilter // ignore: cast_nullable_to_non_nullable
              as StoryMood?,
      tagFilter: freezed == tagFilter
          ? _value.tagFilter
          : tagFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  const _$SearchStateImpl(
      {this.query = '',
      final List<StoryEntity> results = const [],
      this.isLoading = false,
      this.error,
      this.moodFilter,
      this.tagFilter})
      : _results = results;

  @override
  @JsonKey()
  final String query;
  final List<StoryEntity> _results;
  @override
  @JsonKey()
  List<StoryEntity> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final StoryMood? moodFilter;
  @override
  final String? tagFilter;

  @override
  String toString() {
    return 'SearchState(query: $query, results: $results, isLoading: $isLoading, error: $error, moodFilter: $moodFilter, tagFilter: $tagFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.moodFilter, moodFilter) ||
                other.moodFilter == moodFilter) &&
            (identical(other.tagFilter, tagFilter) ||
                other.tagFilter == tagFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_results),
      isLoading,
      error,
      moodFilter,
      tagFilter);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      __$$SearchStateImplCopyWithImpl<_$SearchStateImpl>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  const factory _SearchState(
      {final String query,
      final List<StoryEntity> results,
      final bool isLoading,
      final String? error,
      final StoryMood? moodFilter,
      final String? tagFilter}) = _$SearchStateImpl;

  @override
  String get query;
  @override
  List<StoryEntity> get results;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  StoryMood? get moodFilter;
  @override
  String? get tagFilter;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
