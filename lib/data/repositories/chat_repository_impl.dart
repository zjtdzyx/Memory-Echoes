import 'package:memory_echoes/data/datasources/remote/firestore_chat_datasource.dart';
import 'package:memory_echoes/data/models/chat_message_model.dart';
import 'package:memory_echoes/domain/entities/chat_message_entity.dart';
import 'package:memory_echoes/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirestoreChatDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<ChatMessageEntity>> getChatMessages(String userId) {
    return _remoteDataSource.getChatMessages(userId);
  }

  @override
  Future<void> saveChatMessage(String userId, ChatMessageEntity message) {
    final messageModel = _convertToChatMessageModel(message);
    return _remoteDataSource.saveChatMessage(userId, messageModel);
  }

  @override
  Future<void> clearChatHistory(String userId) {
    return _remoteDataSource.clearChatHistory(userId);
  }

  @override
  Future<List<ChatMessageEntity>> getRecentChatMessages(String userId,
      {int limit = 50}) async {
    final messages =
        await _remoteDataSource.getRecentChatMessages(userId, limit: limit);
    return messages.cast<ChatMessageEntity>();
  }

  ChatMessageModel _convertToChatMessageModel(ChatMessageEntity message) {
    if (message is ChatMessageModel) {
      return message;
    }

    return ChatMessageModel(
      id: message.id,
      content: message.content,
      isUser: message.isUser,
      timestamp: message.timestamp,
    );
  }
}
