import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/remote/firestore_story_datasource.dart';
import '../models/story_model.dart';

class StoryRepositoryImpl implements StoryRepository {
  final FirestoreStoryDataSource _storyDataSource;

  StoryRepositoryImpl(this._storyDataSource);

  @override
  Future<List<StoryEntity>> getUserStories(String userId) async {
    final storyModels = await _storyDataSource.getUserStories(userId);
    return storyModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<StoryEntity>> getPublicStories({int limit = 20, String? lastStoryId}) async {
    final storyModels = await _storyDataSource.getPublicStories(limit: limit, lastStoryId: lastStoryId);
    return storyModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<StoryEntity> getStoryById(String storyId) async {
    final storyModel = await _storyDataSource.getStoryById(storyId);
    return storyModel.toEntity();
  }

  @override
  Future<StoryEntity> createStory(StoryEntity story) async {
    final storyModel = StoryModel.fromEntity(story);
    final createdModel = await _storyDataSource.createStory(storyModel);
    return createdModel.toEntity();
  }

  @override
  Future<StoryEntity> updateStory(StoryEntity story) async {
    final storyModel = StoryModel.fromEntity(story);
    final updatedModel = await _storyDataSource.updateStory(storyModel);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteStory(String storyId) async {
    await _storyDataSource.deleteStory(storyId);
  }

  @override
  Future<void> likeStory(String storyId, String userId) async {
    await _storyDataSource.likeStory(storyId, userId);
  }

  @override
  Future<void> unlikeStory(String storyId, String userId) async {
    await _storyDataSource.unlikeStory(storyId, userId);
  }

  @override
  Future<List<StoryEntity>> searchStories(String query, {String? userId}) async {
    final storyModels = await _storyDataSource.searchStories(query, userId: userId);
    return storyModels.map((model) => model.toEntity()).toList();
  }
}
