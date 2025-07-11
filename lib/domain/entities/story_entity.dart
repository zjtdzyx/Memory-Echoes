class StoryEntity {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String> tags;
  final List<String> imageUrls;
  final String? audioUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final int likesCount;
  final int commentsCount;
  final StoryMood mood;

  const StoryEntity({
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
    this.mood = StoryMood.neutral,
  });

  StoryEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? tags,
    List<String>? imageUrls,
    String? audioUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    int? likesCount,
    int? commentsCount,
    StoryMood? mood,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      mood: mood ?? this.mood,
    );
  }
}

enum StoryMood {
  happy,
  sad,
  nostalgic,
  peaceful,
  excited,
  neutral,
}
