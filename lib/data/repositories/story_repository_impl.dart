import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/remote/firestore_story_datasource.dart';
import '../models/story_model.dart';

class StoryRepositoryImpl implements StoryRepository {
  final FirestoreStoryDataSource _firestoreStoryDataSource;

  StoryRepositoryImpl(this._firestoreStoryDataSource);

  @override
  Future<List<StoryEntity>> getUserStories(String userId) async {
    final storyModels = await _firestoreStoryDataSource.getUserStories(userId);
    return storyModels;
  }

  @override
  Future<List<StoryEntity>> getPublicStories(
      {int limit = 20, String? lastStoryId}) async {
    final storyModels = await _firestoreStoryDataSource.getPublicStories(
        limit: limit, lastStoryId: lastStoryId);
    return storyModels;
  }

  @override
  Future<StoryEntity> getStoryById(String storyId) async {
    final storyModel = await _firestoreStoryDataSource.getStoryById(storyId);
    return storyModel;
  }

  @override
  Future<StoryEntity> createStory(StoryEntity story) async {
    final storyModel = StoryModel.fromEntity(story);
    final createdModel =
        await _firestoreStoryDataSource.createStory(storyModel);
    return createdModel;
  }

  @override
  Future<StoryEntity> updateStory(StoryEntity story) async {
    final storyModel = StoryModel.fromEntity(story);
    final updatedModel =
        await _firestoreStoryDataSource.updateStory(storyModel);
    return updatedModel;
  }

  @override
  Future<void> deleteStory(String storyId) async {
    await _firestoreStoryDataSource.deleteStory(storyId);
  }

  @override
  Future<void> likeStory(String storyId, String userId) async {
    await _firestoreStoryDataSource.likeStory(storyId, userId);
  }

  @override
  Future<void> unlikeStory(String storyId, String userId) async {
    await _firestoreStoryDataSource.unlikeStory(storyId, userId);
  }

  @override
  Future<List<StoryEntity>> searchStories(String query,
      {String? userId, String? mood, String? tag}) async {
    final storyModels = await _firestoreStoryDataSource.searchStories(query,
        userId: userId, mood: mood, tag: tag);
    return storyModels;
  }
}
