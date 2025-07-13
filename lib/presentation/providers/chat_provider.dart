import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/ai_chat_usecases.dart';
import '../../domain/usecases/chat_usecases.dart';
import '../../dependency_injection.dart';
import '../../data/models/chat_message_model.dart';

part 'chat_provider.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatMessageEntity> messages,
    @Default(false) bool isLoading,
    String? error,
  }) = _ChatState;
}

class ChatNotifier extends StateNotifier<ChatState> {
  final PostChatMessageUseCase _postChatMessageUseCase;
  final GenerateStoryFromChatUseCase _generateStoryFromChatUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final SaveChatMessageUseCase _saveChatMessageUseCase;
  final ClearChatHistoryUseCase _clearChatHistoryUseCase;

  ChatNotifier(
    this._postChatMessageUseCase,
    this._generateStoryFromChatUseCase,
    this._getChatMessagesUseCase,
    this._saveChatMessageUseCase,
    this._clearChatHistoryUseCase,
  ) : super(const ChatState());

  void loadChatHistory(String userId) {
    _getChatMessagesUseCase(userId).listen(
      (messages) {
        state = state.copyWith(messages: messages);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
      },
    );
  }

  void clearChat(String userId) async {
    try {
      await _clearChatHistoryUseCase(userId);
      state = state.copyWith(messages: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendMessage(String content, String userId) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // 保存用户消息到数据库
    await _saveChatMessageUseCase(userId, userMessage);

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final aiResponse = await _postChatMessageUseCase(state.messages);

      // 保存AI回复到数据库
      await _saveChatMessageUseCase(userId, aiResponse);

      state = state.copyWith(
        messages: [...state.messages, aiResponse],
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
    if (state.messages.isEmpty) {
      state = state.copyWith(
        error: '没有对话记录可生成故事',
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _generateStoryFromChatUseCase(
        userId: userId,
        messages: state.messages,
        title: title,
      );

      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '生成故事失败: ${e.toString()}',
      );
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(
    ref.read(postChatMessageUseCaseProvider),
    ref.read(generateStoryFromChatUseCaseProvider),
    ref.read(getChatMessagesUseCaseProvider),
    ref.read(saveChatMessageUseCaseProvider),
    ref.read(clearChatHistoryUseCaseProvider),
  );
});
