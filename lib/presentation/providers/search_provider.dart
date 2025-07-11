import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/story_usecases.dart';
import '../../dependency_injection.dart';
import '../../domain/enums/story_mood.dart';
import 'auth_provider.dart';

// 使用 AsyncValue 来管理异步状态
final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<StoryEntity>>>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
  final Ref _ref;

  SearchNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final searchUseCase = _ref.read(searchStoriesUseCaseProvider);
      final userId = _ref
          .read(authStateProvider)
          .maybeWhen(authenticated: (user) => user.uid, orElse: () => null);
      final stories = await searchUseCase(query, userId: userId);
      state = AsyncValue.data(stories);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> searchByMood(StoryMood mood) async {
    state = const AsyncValue.loading();
    try {
      final searchUseCase = _ref.read(searchStoriesUseCaseProvider);
      final userId = _ref
          .read(authStateProvider)
          .maybeWhen(authenticated: (user) => user.uid, orElse: () => null);
      final stories = await searchUseCase('', mood: mood.name, userId: userId);
      state = AsyncValue.data(stories);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
