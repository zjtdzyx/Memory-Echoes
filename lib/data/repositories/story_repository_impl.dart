import 'package:memory_echoes/data/datasources/remote/firestore_story_datasource.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final FirestoreStoryDataSource _remoteDataSource;

  StoryRepositoryImpl(this._remoteDataSource);

  // 保留流式获取以供内部使用
  // ignore: unused_element
  Stream<List<StoryEntity>> _getStoriesStream(String userId) {
    return _remoteDataSource.getStories(userId);
  }

  @override
  Future<List<StoryEntity>> getUserStories(String userId) async {
    // 将流转换为一次性列表
    return await _remoteDataSource.getStories(userId).first;
  }

  @override
  Future<List<StoryEntity>> getPublicStories() async {
    // 公开故事：查询公共且最新的故事
    return await _remoteDataSource.searchStories(
        query: '', mood: null, tag: null);
  }

  @override
  Future<StoryEntity> getStoryById(String storyId) {
    return _remoteDataSource.getStoryById(storyId);
  }

  @override
  Future<void> createStory(StoryEntity story) {
    // The datasource expects a model, so we might need a conversion if they differ.
    // Assuming StoryEntity can be represented as StoryModel for now.
    return _remoteDataSource.createStory(story as dynamic);
  }

  @override
  Future<void> updateStory(StoryEntity story) {
    return _remoteDataSource.updateStory(story as dynamic);
  }

  @override
  Future<void> deleteStory(String storyId) {
    return _remoteDataSource.deleteStory(storyId);
  }

  @override
  Future<List<StoryEntity>> searchStories({
    required String query,
    String? mood,
    String? tag,
  }) {
    return _remoteDataSource.searchStories(query: query, mood: mood, tag: tag);
  }
}
