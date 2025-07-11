import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/ai_chat_usecases.dart';
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

  ChatNotifier(this._postChatMessageUseCase, this._generateStoryFromChatUseCase)
      : super(const ChatState());

  void clearChat() {
    state = state.copyWith(messages: []);
  }

  Future<void> sendMessage(String content, String userId) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final aiResponse = await _postChatMessageUseCase(state.messages);
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
    if (state.messages.isEmpty) return;

    state = state.copyWith(isLoading: true);
    try {
      await _generateStoryFromChatUseCase(
        userId: userId,
        messages: state.messages,
        title: title,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(
    ref.read(postChatMessageUseCaseProvider),
    ref.read(generateStoryFromChatUseCaseProvider),
  );
});
