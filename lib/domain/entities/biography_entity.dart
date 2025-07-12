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
}

enum BiographyTheme {
  classic,
  modern,
  vintage,
  elegant,
}
