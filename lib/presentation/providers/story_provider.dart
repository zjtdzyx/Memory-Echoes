import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/story_usecases.dart';
import '../../dependency_injection.dart';

// 用户故事提供者
final userStoriesProvider =
    StreamProvider.family<List<StoryEntity>, String>((ref, userId) {
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
    _listenToStories();
  }

  void _listenToStories() {
    // 监听故事流的变化
    _getUserStoriesUseCase(_userId).listen(
      (stories) {
        state = AsyncValue.data(stories);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  Future<void> createStory(StoryEntity story) async {
    try {
      await _createStoryUseCase(story);
      // 不需要手动刷新，流会自动更新
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateStory(StoryEntity story) async {
    try {
      await _updateStoryUseCase(story);
      // 不需要手动刷新，流会自动更新
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteStory(String storyId) async {
    try {
      await _deleteStoryUseCase(storyId);
      // 不需要手动刷新，流会自动更新
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    // 流会自动刷新，这里不需要做任何事情
  }
}

final storyListProvider = StateNotifierProvider.family<StoryListNotifier,
    AsyncValue<List<StoryEntity>>, String>((ref, userId) {
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
final storyDetailProvider =
    FutureProvider.family<StoryEntity, String>((ref, storyId) async {
  final getStoryByIdUseCase = ref.read(getStoryByIdUseCaseProvider);
  return await getStoryByIdUseCase(storyId);
});

// 最近故事提供者
final recentStoriesProvider = FutureProvider<List<StoryEntity>>((ref) async {
  try {
    final getPublicStoriesUseCase = ref.read(getPublicStoriesUseCaseProvider);
    final stories = await getPublicStoriesUseCase();
    // 返回最近的5个故事
    return stories.take(5).toList();
  } catch (e) {
    throw Exception('Failed to load recent stories: $e');
  }
});

// 用户最近故事提供者
final userRecentStoriesProvider =
    StreamProvider.family<List<StoryEntity>, String>((ref, userId) {
  try {
    final getUserStoriesUseCase = ref.read(getUserStoriesUseCaseProvider);
    return getUserStoriesUseCase(userId)
        .map((stories) => stories.take(5).toList());
  } catch (e) {
    throw Exception('Failed to load user recent stories: $e');
  }
});
