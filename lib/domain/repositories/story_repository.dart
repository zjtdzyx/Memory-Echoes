import 'package:memory_echoes/domain/entities/story_entity.dart';

abstract class StoryRepository {
  Stream<List<StoryEntity>> getStories(String userId);
  Future<StoryEntity> getStoryById(String storyId);
  Future<void> createStory(StoryEntity story);
  Future<void> updateStory(StoryEntity story);
  Future<void> deleteStory(String storyId);
  Future<List<StoryEntity>> searchStories(
      {required String query, String? mood, String? tag});
}
