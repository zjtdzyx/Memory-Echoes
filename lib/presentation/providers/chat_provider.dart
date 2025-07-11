import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/ai_chat_usecases.dart';
import '../../dependency_injection.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(
    ref.read(sendChatMessageUseCaseProvider),
    ref.read(generateStoryFromChatUseCaseProvider),
  );
});

class ChatNotifier extends StateNotifier<ChatState> {
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final GenerateStoryFromChatUseCase _generateStoryFromChatUseCase;

  ChatNotifier(
    this._sendChatMessageUseCase,
    this._generateStoryFromChatUseCase,
  ) : super(ChatState(
    messages: [
      ChatMessageEntity(
        id: 'welcome',
        userId: 'system',
        content: '你好！我是你的记忆陪伴者，很高兴与你相遇。你想和我分享什么回忆吗？',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ],
  ));

  Future<void> sendMessage(String content, String userId) async {
    if (content.trim().isEmpty) return;

    // 添加用户消息
    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // 获取AI回复
      final aiResponse = await _sendChatMessageUseCase(content, state.messages);
      
      final aiMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'ai',
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      final errorMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'ai',
        content: '抱歉，我现在无法回应。请稍后再试。',
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> generateStoryFromChat(String userId, String title) async {
    if (state.messages.length < 2) return;

    state = state.copyWith(isGeneratingStory: true);

    try {
      final story = await _generateStoryFromChatUseCase(
        userId: userId,
        messages: state.messages,
        title: title,
      );

      state = state.copyWith(
        isGeneratingStory: false,
        generatedStory: story,
      );
    } catch (e) {
      state = state.copyWith(
        isGeneratingStory: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    state = ChatState(
      messages: [
        ChatMessageEntity(
          id: 'welcome',
          userId: 'system',
          content: '你好！我是你的记忆陪伴者，很高兴与你相遇。你想和我分享什么回忆吗？',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }
}

class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isLoading;
  final bool isGeneratingStory;
  final String? error;
  final dynamic generatedStory;

  const ChatState({
    required this.messages,
    this.isLoading = false,
    this.isGeneratingStory = false,
    this.error,
    this.generatedStory,
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    bool? isGeneratingStory,
    String? error,
    dynamic generatedStory,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isGeneratingStory: isGeneratingStory ?? this.isGeneratingStory,
      error: error ?? this.error,
      generatedStory: generatedStory ?? this.generatedStory,
    );
  }
}
