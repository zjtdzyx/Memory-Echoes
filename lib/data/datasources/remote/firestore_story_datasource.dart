import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/story_model.dart';

abstract class FirestoreStoryDataSource {
  Future<List<StoryModel>> getUserStories(String userId);
  Future<List<StoryModel>> getPublicStories({int limit = 20, String? lastStoryId});
  Future<StoryModel> getStoryById(String storyId);
  Future<StoryModel> createStory(StoryModel story);
  Future<StoryModel> updateStory(StoryModel story);
  Future<void> deleteStory(String storyId);
  Future<void> likeStory(String storyId, String userId);
  Future<void> unlikeStory(String storyId, String userId);
  Future<List<StoryModel>> searchStories(String query, {String? userId});
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
  Future<List<StoryModel>> getPublicStories({int limit = 20, String? lastStoryId}) async {
    Query query = _firestore
        .collection('stories')
        .where('is_public', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(limit);

    if (lastStoryId != null) {
      final lastDoc = await _firestore.collection('stories').doc(lastStoryId).get();
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
    final likeRef = _firestore.collection('story_likes').doc('${storyId}_$userId');
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
    final likeRef = _firestore.collection('story_likes').doc('${storyId}_$userId');
    batch.delete(likeRef);

    // 减少点赞数
    final storyRef = _firestore.collection('stories').doc(storyId);
    batch.update(storyRef, {
      'likes_count': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  @override
  Future<List<StoryModel>> searchStories(String query, {String? userId}) async {
    try {
      // 使用多个查询条件进行搜索
      final List<Future<QuerySnapshot>> searchQueries = [];

      // 按标题搜索
      searchQueries.add(
        _firestore
            .collection('stories')
            .where('is_public', isEqualTo: true)
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThanOrEqualTo: '$query\uf8ff')
            .limit(10)
            .get(),
      );

      // 按标签搜索
      searchQueries.add(
        _firestore
            .collection('stories')
            .where('is_public', isEqualTo: true)
            .where('tags', arrayContains: query)
            .limit(10)
            .get(),
      );

      // 如果指定了用户ID，也搜索该用户的私有故事
      if (userId != null) {
        searchQueries.add(
          _firestore
              .collection('stories')
              .where('user_id', isEqualTo: userId)
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: '$query\uf8ff')
              .limit(10)
              .get(),
        );
      }

      final results = await Future.wait(searchQueries);
      final Set<String> seenIds = <String>{};
      final List<StoryModel> stories = [];

      for (final querySnapshot in results) {
        for (final doc in querySnapshot.docs) {
          if (!seenIds.contains(doc.id)) {
            seenIds.add(doc.id);
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            stories.add(StoryModel.fromJson(data));
          }
        }
      }

      // 按创建时间排序
      stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return stories;
    } catch (e) {
      throw Exception('搜索失败: $e');
    }
  }
}

extension on StoryModel {
  StoryModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? tags,
    List<String>? imageUrls,
    String? audioUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    int? likesCount,
    int? commentsCount,
    String? mood,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      mood: mood ?? this.mood,
    );
  }
}
