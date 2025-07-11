import '../enums/story_mood.dart';

class StoryEntity {
  final String? id;
  final String userId;
  final String title;
  final String content;
  final List<String> tags;
  final List<String>? imageUrls;
  final StoryMood? mood;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final List<String> likedBy;

  const StoryEntity({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.imageUrls,
    this.mood,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = false,
    this.likedBy = const [],
  });

  StoryEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? tags,
    List<String>? imageUrls,
    StoryMood? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    List<String>? likedBy,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}
