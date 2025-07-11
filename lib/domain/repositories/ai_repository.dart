import 'package:memory_echoes/domain/entities/chat_message_entity.dart';

abstract class AiRepository {
  Future<ChatMessageEntity> postChatMessage(List<ChatMessageEntity> messages);
  Future<List<String>> generateStoryTags(String content);
}
