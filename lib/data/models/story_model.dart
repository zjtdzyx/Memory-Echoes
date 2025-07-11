import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/story_entity.dart';
import '../../domain/enums/story_mood.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel extends StoryEntity with _$StoryModel {
  const factory StoryModel({
    String? id,
    required String userId,
    required String title,
    required String content,
    List<String>? imageUrls,
    StoryMood? mood,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required List<String> tags,
    required bool isPublic,
    required List<String> likedBy,
  }) = _StoryModel;

  factory StoryModel.fromEntity(StoryEntity entity) {
    return StoryModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      content: entity.content,
      imageUrls: entity.imageUrls,
      mood: entity.mood,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      tags: entity.tags,
      isPublic: entity.isPublic,
      likedBy: entity.likedBy,
    );
  }

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
