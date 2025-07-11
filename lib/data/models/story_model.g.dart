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
          .toList(),
      mood: $enumDecodeNullable(_$StoryMoodEnumMap, json['mood']),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isPublic: json['isPublic'] as bool,
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$StoryModelImplToJson(_$StoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'mood': _$StoryMoodEnumMap[instance.mood],
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'tags': instance.tags,
      'isPublic': instance.isPublic,
      'likedBy': instance.likedBy,
    };

const _$StoryMoodEnumMap = {
  StoryMood.happy: 'happy',
  StoryMood.sad: 'sad',
  StoryMood.adventurous: 'adventurous',
  StoryMood.mysterious: 'mysterious',
  StoryMood.romantic: 'romantic',
  StoryMood.humorous: 'humorous',
};
