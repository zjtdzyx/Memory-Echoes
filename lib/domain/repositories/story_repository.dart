import '../entities/story_entity.dart';

abstract class StoryRepository {
  Future<List<StoryEntity>> getUserStories(String userId);
  Future<List<StoryEntity>> getPublicStories();
  Future<StoryEntity> getStoryById(String storyId);
  Future<void> createStory(StoryEntity story);
  Future<void> updateStory(StoryEntity story);
  Future<void> deleteStory(String storyId);
  Future<List<StoryEntity>> searchStories({
    required String query,
    String? mood,
    String? tag,
  });
}
