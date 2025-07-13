import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatMessagesUseCase {
  final ChatRepository _repository;

  GetChatMessagesUseCase(this._repository);

  Stream<List<ChatMessageEntity>> call(String userId) {
    return _repository.getChatMessages(userId);
  }
}

class SaveChatMessageUseCase {
  final ChatRepository _repository;

  SaveChatMessageUseCase(this._repository);

  Future<void> call(String userId, ChatMessageEntity message) {
    return _repository.saveChatMessage(userId, message);
  }
}

class ClearChatHistoryUseCase {
  final ChatRepository _repository;

  ClearChatHistoryUseCase(this._repository);

  Future<void> call(String userId) {
    return _repository.clearChatHistory(userId);
  }
}

class GetRecentChatMessagesUseCase {
  final ChatRepository _repository;

  GetRecentChatMessagesUseCase(this._repository);

  Future<List<ChatMessageEntity>> call(String userId, {int limit = 50}) {
    return _repository.getRecentChatMessages(userId, limit: limit);
  }
}
