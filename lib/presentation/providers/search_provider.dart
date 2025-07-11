import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../../dependency_injection.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<StoryEntity>>>((ref) {
  return SearchNotifier(ref.read(storyRepositoryProvider));
});

class SearchNotifier extends StateNotifier<AsyncValue<List<StoryEntity>>> {
  final StoryRepository _storyRepository;
  String _lastQuery = '';

  SearchNotifier(this._storyRepository) : super(const AsyncValue.data([]));

  Future<void> searchStories(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    if (query == _lastQuery) return;
    _lastQuery = query;

    state = const AsyncValue.loading();

    try {
      final results = await _storyRepository.searchStories(query);
      state = AsyncValue.data(results);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearSearch() {
    _lastQuery = '';
    state = const AsyncValue.data([]);
  }

  Future<void> searchByMood(StoryMood mood) async {
    state = const AsyncValue.loading();

    try {
      // TODO: 实现按情感搜索
      final results = await _storyRepository.searchStories('');
      final filteredResults = results.where((story) => story.mood == mood).toList();
      state = AsyncValue.data(filteredResults);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> searchByDateRange(DateTime startDate, DateTime endDate) async {
    state = const AsyncValue.loading();

    try {
      // TODO: 实现按时间范围搜索
      final results = await _storyRepository.searchStories('');
      final filteredResults = results.where((story) {
        return story.createdAt.isAfter(startDate) && story.createdAt.isBefore(endDate);
      }).toList();
      state = AsyncValue.data(filteredResults);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
