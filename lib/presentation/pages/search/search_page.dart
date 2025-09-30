import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/story/story_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../providers/search_provider.dart';
import '../../../domain/enums/story_mood.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: const InputDecoration(
            hintText: '搜索故事、标签...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _currentQuery = query;
            });
            if (query.trim().isNotEmpty) {
              ref.read(searchProvider.notifier).searchStories(query.trim());
            } else {
              ref.read(searchProvider.notifier).clearSearch();
            }
          },
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              ref.read(searchProvider.notifier).searchStories(query.trim());
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                ref.read(searchProvider.notifier).searchStories(query);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索建议/历史
          if (_currentQuery.isEmpty) ...[
            _buildSearchSuggestions(),
          ],

          // 搜索结果
          Expanded(
            child: () {
              if (searchState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (searchState.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '搜索失败',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        searchState.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final results = searchState.results;

              if (_currentQuery.isEmpty) {
                return _buildRecentSearches();
              }

              if (results.isEmpty) {
                return const EmptyState(
                  message: '没有找到相关故事\n尝试使用其他关键词搜索',
                  icon: Icons.search_off,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final story = results[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: StoryCard(
                      story: story,
                      showAuthor: true,
                      onTap: () => context.push('/story/${story.id}'),
                      onLike: () => _handleLike(story.id),
                    ),
                  );
                },
              );
            }(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = [
      '温暖回忆',
      '童年时光',
      '家人朋友',
      '旅行故事',
      '成长经历',
      '美食记忆',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '热门搜索',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  _searchController.text = suggestion;
                  setState(() {
                    _currentQuery = suggestion;
                  });
                  ref.read(searchProvider.notifier).searchStories(suggestion);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    // TODO: 实现搜索历史
    return const EmptyState(
      message: '开始搜索\n输入关键词来搜索你感兴趣的故事',
      icon: Icons.history,
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '搜索筛选',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),

            // 时间筛选
            Text(
              '时间范围',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('最近一周'),
                  selected: false,
                  onSelected: (selected) {
                    // TODO: 实现时间筛选
                  },
                ),
                FilterChip(
                  label: const Text('最近一月'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('最近一年'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 情感筛选
            Text(
              '情感类型',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: StoryMood.values.map((mood) {
                return FilterChip(
                  label: Text(_getMoodText(mood)),
                  selected: false,
                  onSelected: (selected) {
                    // TODO: 实现情感筛选
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('重置'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: 应用筛选条件
                    },
                    child: const Text('应用'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMoodText(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return '开心';
      case StoryMood.sad:
        return '难过';
      case StoryMood.nostalgic:
        return '怀念';
      case StoryMood.peaceful:
        return '平静';
      case StoryMood.excited:
        return '兴奋';
      case StoryMood.neutral:
        return '平常';
      case StoryMood.adventurous:
        return '冒险';
    }
    return ''; // fallback
  }

  void _handleLike(String? storyId) {
    // TODO: 实现点赞功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('点赞成功')),
    );
  }
}
