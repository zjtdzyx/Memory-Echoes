import '../entities/story_entity.dart';
import '../repositories/story_repository.dart';
import '../repositories/ai_repository.dart';
import '../enums/story_mood.dart';

class CreateStoryUseCase {
  final StoryRepository _storyRepository;
  final AiRepository _aiRepository;

  CreateStoryUseCase(this._storyRepository, this._aiRepository);

  Future<StoryEntity> call({
    required String userId,
    required String title,
    required String content,
    List<String>? imageUrls,
    bool isPublic = false,
  }) async {
    if (title.isEmpty || content.isEmpty) {
      throw Exception('标题和内容不能为空');
    }

    // 使用AI生成标签
    final tags = await _aiRepository.generateStoryTags(content);

    // 分析内容情感
    final mood = _analyzeMood(content);

    final story = StoryEntity(
      id: '', // 将由仓库层生成
      userId: userId,
      title: title,
      content: content,
      tags: tags,
      imageUrls: imageUrls ?? [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPublic: isPublic,
      mood: mood,
    );

    return await _storyRepository.createStory(story);
  }

  StoryMood _analyzeMood(String content) {
    // 简单的情感分析逻辑
    final lowerContent = content.toLowerCase();

    if (lowerContent.contains('开心') ||
        lowerContent.contains('快乐') ||
        lowerContent.contains('高兴')) {
      return StoryMood.happy;
    } else if (lowerContent.contains('难过') ||
        lowerContent.contains('伤心') ||
        lowerContent.contains('悲伤')) {
      return StoryMood.sad;
    } else if (lowerContent.contains('冒险') ||
        lowerContent.contains('探索') ||
        lowerContent.contains('发现')) {
      return StoryMood.adventurous;
    } else if (lowerContent.contains('神秘') ||
        lowerContent.contains('谜') ||
        lowerContent.contains('悬疑')) {
      return StoryMood.mysterious;
    } else if (lowerContent.contains('浪漫') ||
        lowerContent.contains('爱') ||
        lowerContent.contains('情')) {
      return StoryMood.romantic;
    }

    return StoryMood.humorous;
  }
}

class GetUserStoriesUseCase {
  final StoryRepository _storyRepository;

  GetUserStoriesUseCase(this._storyRepository);

  Future<List<StoryEntity>> call(String userId) async {
    return await _storyRepository.getUserStories(userId);
  }
}

class GetPublicStoriesUseCase {
  final StoryRepository _storyRepository;

  GetPublicStoriesUseCase(this._storyRepository);

  Future<List<StoryEntity>> call({int limit = 20, String? lastStoryId}) async {
    return await _storyRepository.getPublicStories(
        limit: limit, lastStoryId: lastStoryId);
  }
}

class GetStoryByIdUseCase {
  final StoryRepository _storyRepository;

  GetStoryByIdUseCase(this._storyRepository);

  Future<StoryEntity> call(String storyId) async {
    return await _storyRepository.getStoryById(storyId);
  }
}

class SearchStoriesUseCase {
  final StoryRepository _storyRepository;

  SearchStoriesUseCase(this._storyRepository);

  Future<List<StoryEntity>> call(String query,
      {String? mood, String? tag, String? userId}) async {
    return await _storyRepository.searchStories(query,
        mood: mood, tag: tag, userId: userId);
  }
}

class LikeStoryUseCase {
  final StoryRepository _storyRepository;

  LikeStoryUseCase(this._storyRepository);

  Future<void> call(String storyId, String userId) async {
    await _storyRepository.likeStory(storyId, userId);
  }
}
