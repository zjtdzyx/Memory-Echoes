class BiographyEntity {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String> storyIds;
  final String coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final BiographyTheme theme;

  const BiographyEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.storyIds = const [],
    required this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = false,
    this.theme = BiographyTheme.classic,
  });

  BiographyEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? storyIds,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    BiographyTheme? theme,
  }) {
    return BiographyEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      storyIds: storyIds ?? this.storyIds,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      theme: theme ?? this.theme,
    );
  }
}

enum BiographyTheme {
  classic,
  modern,
  vintage,
  elegant,
}
