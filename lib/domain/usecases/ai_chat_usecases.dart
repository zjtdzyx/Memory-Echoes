import '../entities/chat_message_entity.dart';
import 'package:memory_echoes/data/models/story_model.dart';
import '../repositories/ai_repository.dart';
import '../repositories/story_repository.dart';
import '../enums/story_mood.dart';

class SendChatMessageUseCase {
  final AiRepository _aiRepository;

  SendChatMessageUseCase(this._aiRepository);

  Future<String> call(String message, List<ChatMessageEntity> context) async {
    if (message.trim().isEmpty) {
      throw Exception('消息不能为空');
    }

    return await _aiRepository.getChatResponse(message, context);
  }
}

class GenerateStoryFromChatUseCase {
  final AiRepository _aiRepository;
  final StoryRepository _storyRepository;

  GenerateStoryFromChatUseCase(this._aiRepository, this._storyRepository);

  Future<void> call({
    required String userId,
    required List<ChatMessageEntity> messages,
    required String title,
    bool isPublic = false,
  }) async {
    if (messages.isEmpty) {
      throw Exception('对话记录不能为空');
    }

    // 使用AI从对话生成故事内容
    final storyContent =
        await _aiRepository.generateStoryFromConversation(messages);

    // 生成标签
    final tags = await _aiRepository.generateStoryTags(storyContent);

    final story = StoryModel(
      userId: userId,
      title: title,
      content: storyContent,
      tags: tags,
      createdAt: DateTime.now(),
      mood: StoryMood.neutral,
      isPublic: isPublic,
    );

    await _storyRepository.createStory(story);
  }
}

class PostChatMessageUseCase {
  final AiRepository _repository;

  PostChatMessageUseCase(this._repository);

  Future<ChatMessageEntity> call(List<ChatMessageEntity> messages) {
    return _repository.postChatMessage(messages);
  }
}
