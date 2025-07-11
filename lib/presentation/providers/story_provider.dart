import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/story_usecases.dart';
import '../../dependency_injection.dart';

final userStoriesProvider = StateNotifierProvider.family<UserStoriesNotifier, AsyncValue<List<StoryEntity>>, String>((ref, userId) {
  return UserStoriesNotifier(
    ref.read(getUserStoriesUseCaseProvider),
    userId,
  );
});

final publicStoriesProvider = StateNotifierProvider<PublicStoriesNotifier, AsyncValue<List<StoryEntity>>>((ref) {
  return PublicStoriesNotifier(
    ref.read(getPublicStoriesUseCaseProvider),
  );
});

class UserStoriesNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
  final GetUserStoriesUseCase _getUserStoriesUseCase;
  final String _userId;

  UserStoriesNotifier(this._getUserStoriesUseCase, this._userId) : super(const AsyncValue.loading()) {
    loadStories();
  }

  Future<void> loadStories() async {
    state = const AsyncValue.loading();
    try {
      final stories = await _getUserStoriesUseCase(_userId);
      state = AsyncValue.data(stories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadStories();
  }
}

class PublicStoriesNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
  final GetPublicStoriesUseCase _getPublicStoriesUseCase;
  List<StoryEntity> _stories = [];
  String? _lastStoryId;
  bool _hasMore = true;

  PublicStoriesNotifier(this._getPublicStoriesUseCase) : super(const AsyncValue.loading()) {
    loadStories();
  }

  Future<void> loadStories() async {
    if (state.isLoading) return;
    
    state = const AsyncValue.loading();
    try {
      final stories = await _getPublicStoriesUseCase();
      _stories = stories;
      _lastStoryId = stories.isNotEmpty ? stories.last.id : null;
      _hasMore = stories.length >= 20;
      state = AsyncValue.data(_stories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    try {
      final newStories = await _getPublicStoriesUseCase(lastStoryId: _lastStoryId);
      if (newStories.isNotEmpty) {
        _stories.addAll(newStories);
        _lastStoryId = newStories.last.id;
        _hasMore = newStories.length >= 20;
        state = AsyncValue.data(_stories);
      } else {
        _hasMore = false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    _stories.clear();
    _lastStoryId = null;
    _hasMore = true;
    await loadStories();
  }
}
