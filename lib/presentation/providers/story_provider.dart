import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/story_usecases.dart';
import '../../dependency_injection.dart';
import 'auth_state.dart';
import 'auth_provider.dart';

// 用户故事提供者
final userStoriesProvider = FutureProvider.family<List<StoryEntity>, String>((ref, userId) async {
  final getUserStoriesUseCase = ref.read(getUserStoriesUseCaseProvider);
  return getUserStoriesUseCase(userId);
});

// 故事列表状态通知器
class StoryListNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
  final GetUserStoriesUseCase _getUserStoriesUseCase;
  final CreateStoryUseCase _createStoryUseCase;
  final UpdateStoryUseCase _updateStoryUseCase;
  final DeleteStoryUseCase _deleteStoryUseCase;
  final String _userId;

  StoryListNotifier(
    this._getUserStoriesUseCase,
    this._createStoryUseCase,
    this._updateStoryUseCase,
    this._deleteStoryUseCase,
    this._userId,
  ) : super(const AsyncValue.loading()) {
    _loadStories();
  }

  Future<void> _loadStories() async {
    state = const AsyncValue.loading();
    try {
      final stories = _getUserStoriesUseCase(_userId);
      state = AsyncValue.data(stories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createStory(StoryEntity story) async {
    try {
      await _createStoryUseCase(story);
      await _loadStories(); // 重新加载列表
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateStory(StoryEntity story) async {
    try {
      await _updateStoryUseCase(story);
      await _loadStories(); // 重新加载列表
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteStory(String storyId) async {
    try {
      await _deleteStoryUseCase(storyId);
      await _loadStories(); // 重新加载列表
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadStories();
  }
}

final storyListProvider = StateNotifierProvider.family<StoryListNotifier, AsyncValue<List<StoryEntity>>, String>((ref, userId) {
  return StoryListNotifier(
    ref.read(getUserStoriesUseCaseProvider),
    ref.read(createStoryUseCaseProvider),
    ref.read(updateStoryUseCaseProvider),
    ref.read(deleteStoryUseCaseProvider),
    userId,
  );
});

// 公开故事提供者
final publicStoriesProvider = FutureProvider<List<StoryEntity>>((ref) async {
  final getPublicStoriesUseCase = ref.read(getPublicStoriesUseCaseProvider);
  return await getPublicStoriesUseCase();
});

// 故事详情提供者
final storyDetailProvider = FutureProvider.family<StoryEntity, String>((ref, storyId) async {
  final getStoryByIdUseCase = ref.read(getStoryByIdUseCaseProvider);
  return await getStoryByIdUseCase(storyId);
});
