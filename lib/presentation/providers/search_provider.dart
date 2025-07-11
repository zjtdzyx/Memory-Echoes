import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/enums/story_mood.dart';
import '../../domain/usecases/story_usecases.dart';
import '../../dependency_injection.dart';

part 'search_provider.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
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
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], query: '');
      return;
    }

    state = state.copyWith(
      isLoading: true,
      query: query,
      error: null,
    );

    try {
      final stories = await _searchStoriesUseCase(
        query: query,
        mood: state.moodFilter?.name,
        tag: state.tagFilter,
      );
      state = state.copyWith(
        isLoading: false,
        results: stories,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setMoodFilter(StoryMood? mood) {
    state = state.copyWith(moodFilter: mood);
    if (state.query.isNotEmpty) {
      searchStories(state.query);
    }
  }

  void setTagFilter(String? tag) {
    state = state.copyWith(tagFilter: tag);
    if (state.query.isNotEmpty) {
      searchStories(state.query);
    }
  }

  void clearSearch() {
    state = const SearchState();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    ref.read(searchStoriesUseCaseProvider),
  );
});
