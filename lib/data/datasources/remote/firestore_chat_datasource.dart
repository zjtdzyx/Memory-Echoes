import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_echoes/data/models/chat_message_model.dart';

class FirestoreChatDataSource {
  final FirebaseFirestore _firestore;

  FirestoreChatDataSource(this._firestore);

  Stream<List<ChatMessageModel>> getChatMessages(String userId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessageModel.fromJson(data).copyWith(id: doc.id);
      }).toList();
    });
  }

  Future<void> saveChatMessage(String userId, ChatMessageModel message) async {
    await _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .add(message.toJson());
  }

  Future<void> clearChatHistory(String userId) async {
    final batch = _firestore.batch();
    final messagesRef =
        _firestore.collection('chats').doc(userId).collection('messages');

    final messages = await messagesRef.get();
    for (final doc in messages.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<List<ChatMessageModel>> getRecentChatMessages(String userId,
      {int limit = 50}) async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return ChatMessageModel.fromJson(data).copyWith(id: doc.id);
        })
        .toList()
        .reversed
        .toList();
  }
}
