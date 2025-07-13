import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatMessageEntity>> getChatMessages(String userId);
  Future<void> saveChatMessage(String userId, ChatMessageEntity message);
  Future<void> clearChatHistory(String userId);
  Future<List<ChatMessageEntity>> getRecentChatMessages(String userId,
      {int limit = 50});
}
