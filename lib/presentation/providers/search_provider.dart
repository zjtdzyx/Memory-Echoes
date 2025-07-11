import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/domain/usecases/story_usecases.dart';
import 'package:memory_echoes/dependency_injection.dart';

part 'search_provider.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    String? query,
    @Default([]) List<StoryEntity> results,
    @Default(false) bool isLoading,
    String? error,
    StoryMood? moodFilter,
    String? tagFilter,
  }) = _SearchState;
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchStoriesUseCase _searchStoriesUseCase;

  SearchNotifier(this._searchStoriesUseCase) : super(const SearchState());

  Future<void> searchStories(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(results: [], query: '');
      return;
    }
    state = state.copyWith(isLoading: true, query: query, error: null);
    try {
      final stories = await _searchStoriesUseCase(
        query: query,
        mood: state.moodFilter,
        tag: state.tagFilter,
      );
      state = state.copyWith(isLoading: false, results: stories);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setMoodFilter(StoryMood? mood) {
    state = state.copyWith(moodFilter: mood);
    searchStories(state.query ?? '');
  }

  void setTagFilter(String? tag) {
    state = state.copyWith(tagFilter: tag);
    searchStories(state.query ?? '');
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      results: [],
      isLoading: false,
      error: null,
      moodFilter: null,
      tagFilter: null,
    );
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.watch(searchStoriesUseCaseProvider));
});
