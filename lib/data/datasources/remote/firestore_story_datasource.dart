import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_echoes/data/models/story_model.dart';

class FirestoreStoryDataSource {
  final FirebaseFirestore _firestore;

  FirestoreStoryDataSource(this._firestore);

  Stream<List<StoryModel>> getStories(String userId) {
    return _firestore
        .collection('stories')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StoryModel.fromJson(data).copyWith(id: doc.id);
      }).toList();
    });
  }

  Future<StoryModel> getStoryById(String storyId) async {
    final doc = await _firestore.collection('stories').doc(storyId).get();
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel.fromJson(data).copyWith(id: doc.id);
  }

  Future<void> createStory(StoryModel story) async {
    await _firestore.collection('stories').add(story.toJson());
  }

  Future<void> updateStory(StoryModel story) async {
    await _firestore.collection('stories').doc(story.id).update(story.toJson());
  }

  Future<void> deleteStory(String storyId) async {
    await _firestore.collection('stories').doc(storyId).delete();
  }

  Future<List<StoryModel>> searchStories(
      {required String query, String? mood, String? tag}) async {
    try {
      Query storyQuery =
          _firestore.collection('stories').where('isPublic', isEqualTo: true);

      // 如果有查询条件，先按title排序，再添加其他条件
      if (query.isNotEmpty) {
        storyQuery = storyQuery
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThanOrEqualTo: '$query\uf8ff')
            .orderBy('title'); // 使用title排序，避免索引问题
      } else {
        // 没有查询条件时，可以按创建时间排序
        storyQuery = storyQuery.orderBy('createdAt', descending: true);
      }

      if (mood != null) {
        storyQuery = storyQuery.where('mood', isEqualTo: mood);
      }
      if (tag != null) {
        storyQuery = storyQuery.where('tags', arrayContains: tag);
      }

      final snapshot = await storyQuery.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return StoryModel.fromJson(data).copyWith(id: doc.id);
      }).toList();
    } catch (e) {
      // 如果查询失败，返回空列表而不是抛出异常
      print('搜索故事失败: $e');
      return [];
    }
  }
}
