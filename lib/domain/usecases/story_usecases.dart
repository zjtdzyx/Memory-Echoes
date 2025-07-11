import '../entities/story_entity.dart';
import '../repositories/story_repository.dart';
import '../repositories/ai_repository.dart';

class CreateStoryUseCase {
  final StoryRepository _storyRepository;
  final AiRepository _aiRepository;

  CreateStoryUseCase(this._storyRepository, this._aiRepository);

  Future<StoryEntity> call({
    required String userId,
    required String title,
    required String content,
    List<String>? imageUrls,
    String? audioUrl,
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
      audioUrl: audioUrl,
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
    
    if (lowerContent.contains('开心') || lowerContent.contains('快乐') || lowerContent.contains('高兴')) {
      return StoryMood.happy;
    } else if (lowerContent.contains('难过') || lowerContent.contains('伤心') || lowerContent.contains('悲伤')) {
      return StoryMood.sad;
    } else if (lowerContent.contains('怀念') || lowerContent.contains('回忆') || lowerContent.contains('过去')) {
      return StoryMood.nostalgic;
    } else if (lowerContent.contains('平静') || lowerContent.contains('安静') || lowerContent.contains('宁静')) {
      return StoryMood.peaceful;
    } else if (lowerContent.contains('兴奋') || lowerContent.contains('激动') || lowerContent.contains('刺激')) {
      return StoryMood.excited;
    }
    
    return StoryMood.neutral;
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
    return await _storyRepository.getPublicStories(limit: limit, lastStoryId: lastStoryId);
  }
}

class LikeStoryUseCase {
  final StoryRepository _storyRepository;

  LikeStoryUseCase(this._storyRepository);

  Future<void> call(String storyId, String userId) async {
    await _storyRepository.likeStory(storyId, userId);
  }
}
