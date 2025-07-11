class AppConstants {
  // 应用信息
  static const String appName = '记忆回响';
  static const String appVersion = '1.0.0';
  static const String appDescription = '一个温暖的记忆记录与分享应用';

  // 文件限制
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxAudioSize = 50 * 1024 * 1024; // 50MB
  static const int maxImagesPerStory = 9;
  static const int maxStoryContentLength = 5000;
  static const int maxStoryTitleLength = 100;

  // 分页
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // 缓存
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // AI配置
  static const int maxChatContextLength = 10;
  static const Duration aiResponseTimeout = Duration(seconds: 30);

  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // 网络配置
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // 本地存储键
  static const String userPreferencesKey = 'user_preferences';
  static const String themePreferenceKey = 'theme_preference';
  static const String languagePreferenceKey = 'language_preference';
  static const String searchHistoryKey = 'search_history';
  static const String draftStoriesKey = 'draft_stories';

  // 支持的文件格式
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
  static const List<String> supportedAudioFormats = [
    'mp3', 'm4a', 'wav', 'aac'
  ];

  // 默认值
  static const String defaultAvatarUrl = '';
  static const String defaultCoverImageUrl = '';
  static const int defaultLikesCount = 0;
  static const int defaultCommentsCount = 0;
}
