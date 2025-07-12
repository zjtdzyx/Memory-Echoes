// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiographyModelImpl _$$BiographyModelImplFromJson(Map<String, dynamic> json) =>
    _$BiographyModelImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      storyIds: (json['storyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      coverImageUrl: json['coverImageUrl'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPublic: json['isPublic'] as bool? ?? false,
      theme: $enumDecodeNullable(_$BiographyThemeEnumMap, json['theme']) ??
          BiographyTheme.classic,
    );

Map<String, dynamic> _$$BiographyModelImplToJson(
        _$BiographyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'storyIds': instance.storyIds,
      'coverImageUrl': instance.coverImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isPublic': instance.isPublic,
      'theme': _$BiographyThemeEnumMap[instance.theme]!,
    };

const _$BiographyThemeEnumMap = {
  BiographyTheme.classic: 'classic',
  BiographyTheme.modern: 'modern',
  BiographyTheme.vintage: 'vintage',
  BiographyTheme.elegant: 'elegant',
};
