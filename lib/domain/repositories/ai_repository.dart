import '../entities/chat_message_entity.dart';
import '../entities/story_entity.dart';

abstract class AiRepository {
  Future<String> generateStoryFromConversation(List<ChatMessageEntity> messages);
  Future<String> generateBiographyFromStories(List<StoryEntity> stories);
  Future<String> getChatResponse(String message, List<ChatMessageEntity> context);
  Future<List<String>> generateStoryTags(String content);
  Future<String> improveStoryContent(String content);
}
