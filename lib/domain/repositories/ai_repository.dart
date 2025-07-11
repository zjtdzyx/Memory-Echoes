import '../entities/chat_message_entity.dart';

abstract class AiRepository {
  Future<String> getChatResponse(String message, List<ChatMessageEntity> context);
  Future<ChatMessageEntity> postChatMessage(List<ChatMessageEntity> messages);
  Future<String> generateStoryFromConversation(List<ChatMessageEntity> messages);
  Future<List<String>> generateStoryTags(String content);
}
