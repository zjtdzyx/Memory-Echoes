import 'package:memory_echoes/data/models/chat_message_model.dart';
import 'package:memory_echoes/data/datasources/remote/gemini_api_service.dart';
import 'package:memory_echoes/domain/entities/chat_message_entity.dart';
import 'package:memory_echoes/domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  final GeminiApiService _geminiApiService;

  AiRepositoryImpl(this._geminiApiService);

  @override
  Future<ChatMessageEntity> postChatMessage(
      List<ChatMessageEntity> messages) async {
    try {
      // 获取最后一条用户消息
      final lastUserMessage = messages.where((msg) => msg.isUser).lastOrNull;
      if (lastUserMessage == null) {
        throw Exception('没有找到用户消息');
      }

      // 构建上下文
      final context = messages
          .map((msg) => ChatMessageModel(
                id: msg.id,
                content: msg.content,
                isUser: msg.isUser,
                timestamp: msg.timestamp,
              ))
          .toList();

      // 调用Gemini API
      final response = await _geminiApiService.getChatResponse(
        lastUserMessage.content,
        context,
      );

      return ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      // 如果AI调用失败，返回友好的错误消息
      return ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '很抱歉，我现在无法回应。请稍后再试。',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  Future<List<String>> generateStoryTags(String content) async {
    try {
      return await _geminiApiService.generateStoryTags(content);
    } catch (e) {
      // 如果AI生成失败，返回默认标签
      return ['回忆', '温暖', '故事'];
    }
  }

  @override
  Future<String> getChatResponse(
      String message, List<ChatMessageEntity> context) async {
    try {
      final contextModels = context
          .map((msg) => ChatMessageModel(
                id: msg.id,
                content: msg.content,
                isUser: msg.isUser,
                timestamp: msg.timestamp,
              ))
          .toList();

      return await _geminiApiService.getChatResponse(message, contextModels);
    } catch (e) {
      return '很抱歉，我现在无法回应。请稍后再试。';
    }
  }

  @override
  Future<String> generateStoryFromConversation(
      List<ChatMessageEntity> messages) async {
    try {
      final messageModels = messages
          .map((msg) => ChatMessageModel(
                id: msg.id,
                content: msg.content,
                isUser: msg.isUser,
                timestamp: msg.timestamp,
              ))
          .toList();

      return await _geminiApiService
          .generateStoryFromConversation(messageModels);
    } catch (e) {
      // 如果AI生成失败，创建一个简单的故事
      final userMessages = messages.where((msg) => msg.isUser).toList();
      if (userMessages.isNotEmpty) {
        return '这是一个关于${userMessages.first.content}的温暖回忆...';
      }
      return '这是一个温暖的故事...';
    }
  }
}
