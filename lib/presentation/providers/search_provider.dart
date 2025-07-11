import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../../dependency_injection.dart';

// 搜索状态
class SearchState {
  final List<StoryEntity> results;
  final bool isLoading;
  final String? error;
  final String query;

  SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  SearchState copyWith({
    List<StoryEntity>? results,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}

// 搜索状态通知器
class SearchNotifier extends StateNotifier<SearchState> {
  final StoryRepository _storyRepository;
  String _lastQuery = '';

  SearchNotifier(this._storyRepository) : super(SearchState());

  Future<void> searchStories(String query) async {
    if (query.trim().isEmpty) {
      state = SearchState();
      return;
    }

    if (query == _lastQuery) return;
    _lastQuery = query;

    state = state.copyWith(isLoading: true, query: query);

    try {
      final results = await _storyRepository.searchStories(query);
      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    _lastQuery = '';
    state = SearchState();
  }

  Future<void> searchByMood(StoryMood mood) async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: 实现按情感搜索
      final results = await _storyRepository.searchStories('');
      final filteredResults = results.where((story) => story.mood == mood).toList();
      state = state.copyWith(
        results: filteredResults,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchByDateRange(DateTime startDate, DateTime endDate) async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: 实现按时间范围搜索
      final results = await _storyRepository.searchStories('');
      final filteredResults = results.where((story) {
        return story.createdAt.isAfter(startDate) && story.createdAt.isBefore(endDate);
      }).toList();
      state = state.copyWith(
        results: filteredResults,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// 提供者
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.read(storyRepositoryProvider));
});
