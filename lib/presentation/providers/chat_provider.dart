import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/ai_chat_usecases.dart';
import '../../dependency_injection.dart';

// 聊天状态
class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// 聊天状态通知器
class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GenerateStoryFromChatUseCase _generateStoryFromChatUseCase;

  ChatNotifier(
    this._sendMessageUseCase,
    this._generateStoryFromChatUseCase,
  ) : super(ChatState());

  Future<void> sendMessage(String content, String userId) async {
    // 添加用户消息
    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // 发送消息并获取AI回复
      final aiResponse = await _sendMessageUseCase(content, userId);
      
      final aiMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'ai',
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> generateStoryFromChat(String userId, String title) async {
    try {
      await _generateStoryFromChatUseCase(
        state.messages.map((m) => m.content).join('\n'),
        userId,
        title,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearChat() {
    state = ChatState();
  }
}

// 提供者
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(
    ref.read(sendMessageUseCaseProvider),
    ref.read(generateStoryFromChatUseCaseProvider),
  );
});
