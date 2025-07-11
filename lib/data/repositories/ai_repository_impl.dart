import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/remote/gemini_api_service.dart';
import '../models/chat_message_model.dart';

class AiRepositoryImpl implements AiRepository {
  final GeminiApiService _geminiApiService;

  AiRepositoryImpl(this._geminiApiService);

  @override
  Future<String> generateStoryFromConversation(List<ChatMessageEntity> messages) async {
    final messageModels = messages.map((entity) => ChatMessageModel.fromEntity(entity)).toList();
    return await _geminiApiService.generateStoryFromConversation(messageModels);
  }

  @override
  Future<String> generateBiographyFromStories(List<StoryEntity> stories) async {
    // 实现传记生成逻辑
    final storiesContent = stories.map((story) => '${story.title}\n${story.content}').join('\n\n');
    
    // 这里可以调用专门的传记生成API或使用现有的内容改善功能
    return await _geminiApiService.improveStoryContent(storiesContent);
  }

  @override
  Future<String> getChatResponse(String message, List<ChatMessageEntity> context) async {
    final contextModels = context.map((entity) => ChatMessageModel.fromEntity(entity)).toList();
    return await _geminiApiService.getChatResponse(message, contextModels);
  }

  @override
  Future<List<String>> generateStoryTags(String content) async {
    return await _geminiApiService.generateStoryTags(content);
  }

  @override
  Future<String> improveStoryContent(String content) async {
    return await _geminiApiService.improveStoryContent(content);
  }
}
