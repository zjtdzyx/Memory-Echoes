import 'package:memory_echoes/data/models/chat_message_model.dart';
import 'package:memory_echoes/domain/entities/chat_message_entity.dart';
import 'package:memory_echoes/domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  @override
  Future<ChatMessageEntity> postChatMessage(
      List<ChatMessageEntity> messages) async {
    // Dummy implementation
    await Future.delayed(const Duration(seconds: 1));
    return ChatMessageModel(
      id: DateTime.now().toString(),
      content: 'This is a dummy response from the AI.',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<List<String>> generateStoryTags(String content) async {
    // Dummy implementation
    await Future.delayed(const Duration(seconds: 1));
    return ['dummy', 'ai-generated', 'tag'];
  }
}
