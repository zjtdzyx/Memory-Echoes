import '../entities/story_entity.dart';

abstract class StoryRepository {
  Future<List<StoryEntity>> getUserStories(String userId);
  Future<List<StoryEntity>> getPublicStories(
      {int limit = 20, String? lastStoryId});
  Future<StoryEntity> getStoryById(String storyId);
  Future<StoryEntity> createStory(StoryEntity story);
  Future<StoryEntity> updateStory(StoryEntity story);
  Future<void> deleteStory(String storyId);
  Future<void> likeStory(String storyId, String userId);
  Future<void> unlikeStory(String storyId, String userId);
  Future<List<StoryEntity>> searchStories(String query,
      {String? userId, String? mood, String? tag});
}
