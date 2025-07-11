import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_echoes/data/models/story_model.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';

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
    Query storyQuery =
        _firestore.collection('stories').where('isPublic', isEqualTo: true);

    if (mood != null) {
      storyQuery = storyQuery.where('mood', isEqualTo: mood);
    }
    if (tag != null) {
      storyQuery = storyQuery.where('tags', arrayContains: tag);
    }
    // Note: Firestore does not support full-text search on its own.
    // This query will only find exact matches for the title.
    // A more robust solution would use a third-party search service like Algolia.
    if (query.isNotEmpty) {
      storyQuery = storyQuery
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff');
    }

    final snapshot =
        await storyQuery.orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return StoryModel.fromJson(data).copyWith(id: doc.id);
    }).toList();
  }
}
