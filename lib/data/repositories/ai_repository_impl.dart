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

  @override
  Future<String> getChatResponse(
      String message, List<ChatMessageEntity> context) async {
    // Dummy implementation that simply echoes the last user message
    await Future.delayed(const Duration(milliseconds: 500));
    return 'AI 回复: $message';
  }

  @override
  Future<String> generateStoryFromConversation(
      List<ChatMessageEntity> messages) async {
    // Dummy implementation that combines messages into a simple story
    await Future.delayed(const Duration(milliseconds: 500));
    final combined = messages.map((e) => e.content).join(' ');
    return '从聊天生成的故事: $combined';
  }
}
