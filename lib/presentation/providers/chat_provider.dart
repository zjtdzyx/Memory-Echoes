import 'package:flutter/foundation.dart';
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
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final GenerateStoryFromChatUseCase _generateStoryFromChatUseCase;

  ChatNotifier(
    this._sendChatMessageUseCase,
    this._generateStoryFromChatUseCase,
  ) : super(ChatState());

  Future<void> sendMessage(String text, String userId) async {
    if (text.isEmpty) return;

    final userMessage = ChatMessageEntity(
      text: text,
      sender: MessageSender.user,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final aiResponse = await _sendChatMessageUseCase(text, state.messages);
      final aiMessage = ChatMessageEntity(
        text: aiResponse,
        sender: MessageSender.ai,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> generateStoryFromChat(String userId, String title) async {
    state = state.copyWith(isLoading: true);
    try {
      await _generateStoryFromChatUseCase.call(
        userId: userId,
        messages: state.messages,
        title: title,
      );
      // Maybe add a confirmation message to chat
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// 提供者
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(
    ref.read(sendChatMessageUseCaseProvider),
    ref.read(generateStoryFromChatUseCaseProvider),
  );
});
