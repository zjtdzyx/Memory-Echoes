// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryModelImpl _$$StoryModelImplFromJson(Map<String, dynamic> json) =>
    _$StoryModelImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      mood: $enumDecode(_$StoryMoodEnumMap, json['mood']),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isPublic: json['isPublic'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoryModelImplToJson(_$StoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'createdAt': instance.createdAt.toIso8601String(),
      'mood': _$StoryMoodEnumMap[instance.mood]!,
      'tags': instance.tags,
      'isPublic': instance.isPublic,
    };

const _$StoryMoodEnumMap = {
  StoryMood.happy: 'happy',
  StoryMood.sad: 'sad',
  StoryMood.nostalgic: 'nostalgic',
  StoryMood.peaceful: 'peaceful',
  StoryMood.excited: 'excited',
  StoryMood.neutral: 'neutral',
  StoryMood.adventurous: 'adventurous',
};
