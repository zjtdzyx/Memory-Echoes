import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/story_entity.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String title;
  final String content;
  final List<String> tags;
  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;
  @JsonKey(name: 'audio_url')
  final String? audioUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @JsonKey(name: 'comments_count')
  final int commentsCount;
  final String mood;

  const StoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.imageUrls = const [],
    this.audioUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.mood = 'neutral',
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  factory StoryModel.fromEntity(StoryEntity entity) {
    return StoryModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      content: entity.content,
      tags: entity.tags,
      imageUrls: entity.imageUrls,
      audioUrl: entity.audioUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPublic: entity.isPublic,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      mood: entity.mood.name,
    );
  }

  StoryEntity toEntity() {
    return StoryEntity(
      id: id,
      userId: userId,
      title: title,
      content: content,
      tags: tags,
      imageUrls: imageUrls,
      audioUrl: audioUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPublic: isPublic,
      likesCount: likesCount,
      commentsCount: commentsCount,
      mood: StoryMood.values.firstWhere(
        (e) => e.name == mood,
        orElse: () => StoryMood.neutral,
      ),
    );
  }
}
