import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/story_model.dart';

abstract class FirestoreStoryDataSource {
  Future<List<StoryModel>> getUserStories(String userId);
  Future<List<StoryModel>> getPublicStories(
      {int limit = 20, String? lastStoryId});
  Future<StoryModel> getStoryById(String storyId);
  Future<StoryModel> createStory(StoryModel story);
  Future<StoryModel> updateStory(StoryModel story);
  Future<void> deleteStory(String storyId);
  Future<void> likeStory(String storyId, String userId);
  Future<void> unlikeStory(String storyId, String userId);
  Future<List<StoryModel>> searchStories(String query,
      {String? userId, String? mood, String? tag});
}

class FirestoreStoryDataSourceImpl implements FirestoreStoryDataSource {
  final FirebaseFirestore _firestore;

  FirestoreStoryDataSourceImpl(this._firestore);

  @override
  Future<List<StoryModel>> getUserStories(String userId) async {
    final querySnapshot = await _firestore
        .collection('stories')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return StoryModel.fromJson(data);
    }).toList();
  }

  @override
  Future<List<StoryModel>> getPublicStories(
      {int limit = 20, String? lastStoryId}) async {
    Query query = _firestore
        .collection('stories')
        .where('is_public', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(limit);

    if (lastStoryId != null) {
      final lastDoc =
          await _firestore.collection('stories').doc(lastStoryId).get();
      query = query.startAfterDocument(lastDoc);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return StoryModel.fromJson(data);
    }).toList();
  }

  @override
  Future<StoryModel> getStoryById(String storyId) async {
    final doc = await _firestore.collection('stories').doc(storyId).get();

    if (!doc.exists) {
      throw Exception('故事不存在');
    }

    final data = doc.data()!;
    data['id'] = doc.id;
    return StoryModel.fromJson(data);
  }

  @override
  Future<StoryModel> createStory(StoryModel story) async {
    final docRef = await _firestore.collection('stories').add(story.toJson());

    final createdStory = story.copyWith(id: docRef.id);
    return createdStory;
  }

  @override
  Future<StoryModel> updateStory(StoryModel story) async {
    await _firestore.collection('stories').doc(story.id).update(story.toJson());
    return story;
  }

  @override
  Future<void> deleteStory(String storyId) async {
    await _firestore.collection('stories').doc(storyId).delete();
  }

  @override
  Future<void> likeStory(String storyId, String userId) async {
    final batch = _firestore.batch();

    // 添加点赞记录
    final likeRef =
        _firestore.collection('story_likes').doc('${storyId}_$userId');
    batch.set(likeRef, {
      'story_id': storyId,
      'user_id': userId,
      'created_at': FieldValue.serverTimestamp(),
    });

    // 增加点赞数
    final storyRef = _firestore.collection('stories').doc(storyId);
    batch.update(storyRef, {
      'likes_count': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<void> unlikeStory(String storyId, String userId) async {
    final batch = _firestore.batch();

    // 删除点赞记录
    final likeRef =
        _firestore.collection('story_likes').doc('${storyId}_$userId');
    batch.delete(likeRef);

    // 减少点赞数
    final storyRef = _firestore.collection('stories').doc(storyId);
    batch.update(storyRef, {
      'likes_count': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  @override
  Future<List<StoryModel>> searchStories(String query,
      {String? userId, String? mood, String? tag}) async {
    try {
      Query storiesQuery = _firestore.collection('stories');

      // 基本的公开故事查询
      storiesQuery = storiesQuery.where('is_public', isEqualTo: true);

      // 按情绪过滤
      if (mood != null) {
        storiesQuery = storiesQuery.where('mood', isEqualTo: mood);
      }

      // 按标签过滤
      if (tag != null) {
        storiesQuery = storiesQuery.where('tags', arrayContains: tag);
      }

      // 按关键词搜索 (标题)
      if (query.isNotEmpty) {
        storiesQuery = storiesQuery
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThanOrEqualTo: '$query\uf8ff');
      }

      // 如果提供了 userId，则进行单独的私有故事查询并合并结果
      if (userId != null) {
        // This is a simplified search. A real implementation might use a more
        // complex full-text search solution like Algolia or Typesense, or
        // combine multiple queries. Here we just show a basic example.
        final publicStories = await storiesQuery.limit(15).get();

        Query privateStoriesQuery = _firestore
            .collection('stories')
            .where('user_id', isEqualTo: userId);
        if (query.isNotEmpty) {
          privateStoriesQuery = privateStoriesQuery
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: '$query\uf8ff');
        }

        final privateStories = await privateStoriesQuery.limit(15).get();

        final allDocs = [...publicStories.docs, ...privateStories.docs];
        final seenIds = <String>{};
        final uniqueDocs = allDocs.where((doc) => seenIds.add(doc.id)).toList();

        return uniqueDocs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return StoryModel.fromJson(data);
        }).toList();
      } else {
        final snapshot = await storiesQuery.limit(20).get();
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return StoryModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      throw Exception('搜索失败: $e');
    }
  }
}
