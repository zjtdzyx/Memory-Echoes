import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/domain/repositories/story_repository.dart';

class GetUserStoriesUseCase {
  final StoryRepository _repository;
  GetUserStoriesUseCase(this._repository);

  Future<List<StoryEntity>> call(String userId) {
    return _repository.getUserStories(userId);
  }
}

class GetPublicStoriesUseCase {
  final StoryRepository _repository;
  GetPublicStoriesUseCase(this._repository);

  Future<List<StoryEntity>> call() {
    return _repository.getPublicStories();
  }
}

class GetStoryByIdUseCase {
  final StoryRepository _repository;
  GetStoryByIdUseCase(this._repository);

  Future<StoryEntity> call(String storyId) {
    return _repository.getStoryById(storyId);
  }
}

class CreateStoryUseCase {
  final StoryRepository _repository;
  CreateStoryUseCase(this._repository);

  Future<void> call(StoryEntity story) {
    return _repository.createStory(story);
  }
}

class UpdateStoryUseCase {
  final StoryRepository _repository;
  UpdateStoryUseCase(this._repository);

  Future<void> call(StoryEntity story) {
    return _repository.updateStory(story);
  }
}

class DeleteStoryUseCase {
  final StoryRepository _repository;
  DeleteStoryUseCase(this._repository);

  Future<void> call(String storyId) {
    return _repository.deleteStory(storyId);
  }
}

class SearchStoriesUseCase {
  final StoryRepository _repository;
  SearchStoriesUseCase(this._repository);

  Future<List<StoryEntity>> call(
      {required String query, String? mood, String? tag}) {
    return _repository.searchStories(query: query, mood: mood, tag: tag);
  }
}
