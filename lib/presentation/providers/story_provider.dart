import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/story_usecases.dart';
import '../../dependency_injection.dart';
import 'auth_provider.dart';

// 用户故事提供者
final userStoriesProvider =
    FutureProvider.family<List<StoryEntity>, String>((ref, userId) async {
  final getUserStoriesUseCase = ref.read(getUserStoriesUseCaseProvider);
  return await getUserStoriesUseCase(userId);
});

// 公开故事提供者
final publicStoriesProvider =
    AsyncNotifierProvider<PublicStoriesNotifier, List<StoryEntity>>(() {
  return PublicStoriesNotifier();
});

class PublicStoriesNotifier extends AsyncNotifier<List<StoryEntity>> {
  @override
  Future<List<StoryEntity>> build() async {
    return _fetchStories();
  }

  Future<List<StoryEntity>> _fetchStories() {
    final getPublicStoriesUseCase = ref.read(getPublicStoriesUseCaseProvider);
    return getPublicStoriesUseCase();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStories());
  }

  Future<void> likeStory(String storyId) async {
    final likeStoryUseCase = ref.read(likeStoryUseCaseProvider);
    final authState = ref.read(authStateProvider);

    if (authState is Authenticated) {
      final userId = authState.user.uid;
      await likeStoryUseCase(storyId, userId);

      final previousState = state.valueOrNull ?? [];
      final newState = previousState.map((story) {
        if (story.id == storyId) {
          final newLikedBy = List<String>.from(story.likedBy);
          if (newLikedBy.contains(userId)) {
            newLikedBy.remove(userId);
          } else {
            newLikedBy.add(userId);
          }
          return story.copyWith(likedBy: newLikedBy);
        }
        return story;
      }).toList();
      state = AsyncValue.data(newState);
    }
  }
}

// 故事详情提供者
final storyDetailProvider =
    FutureProvider.family<StoryEntity, String>((ref, storyId) async {
  final getStoryByIdUseCase = ref.read(getStoryByIdUseCaseProvider);
  return await getStoryByIdUseCase(storyId);
});

// class UserStoriesNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
//   final GetUserStoriesUseCase _getUserStoriesUseCase;
//   final String _userId;
//
//   UserStoriesNotifier(this._getUserStoriesUseCase, this._userId) : super(const AsyncValue.loading()) {
//     loadStories();
//   }
//
//   Future<void> loadStories() async {
//     state = const AsyncValue.loading();
//     try {
//       final stories = await _getUserStoriesUseCase(_userId);
//       state = AsyncValue.data(stories);
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }
//
//   Future<void> refresh() async {
//     await loadStories();
//   }
// }

// class PublicStoriesNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
//   final GetPublicStoriesUseCase _getPublicStoriesUseCase;
//   List<StoryEntity> _stories = [];
//   String? _lastStoryId;
//   bool _hasMore = true;
//
//   PublicStoriesNotifier(this._getPublicStoriesUseCase) : super(const AsyncValue.loading()) {
//     loadStories();
//   }
//
//   Future<void> loadStories() async {
//     if (state.isLoading) return;
//
//     state = const AsyncValue.loading();
//     try {
//       final stories = await _getPublicStoriesUseCase();
//       _stories = stories;
//       _lastStoryId = stories.isNotEmpty ? stories.last.id : null;
//       _hasMore = stories.length >= 20;
//       state = AsyncValue.data(_stories);
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }
//
//   Future<void> loadMore() async {
//     if (!_hasMore || state.isLoading) return;
//
//     try {
//       final newStories = await _getPublicStoriesUseCase(lastStoryId: _lastStoryId);
//       if (newStories.isNotEmpty) {
//         _stories.addAll(newStories);
//         _lastStoryId = newStories.last.id;
//         _hasMore = newStories.length >= 20;
//         state = AsyncValue.data(_stories);
//       } else {
//         _hasMore = false;
//       }
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }
//
//   Future<void> refresh() async {
//     _stories.clear();
//     _lastStoryId = null;
//     _hasMore = true;
//     await loadStories();
//   }
// }
