import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/story/story_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../providers/story_provider.dart';

class SocialSquarePage extends ConsumerStatefulWidget {
  const SocialSquarePage({super.key});

  @override
  ConsumerState<SocialSquarePage> createState() => _SocialSquarePageState();
}

class _SocialSquarePageState extends ConsumerState<SocialSquarePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(publicStoriesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(publicStoriesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('社交广场'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索功能
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(publicStoriesProvider.notifier).refresh();
        },
        child: storiesAsync.when(
          data: (stories) {
            if (stories.isEmpty) {
              return const EmptyState(
                icon: Icons.public_outlined,
                title: '暂无公开故事',
                subtitle: '成为第一个分享温暖回忆的人吧',
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: stories.length + 1, // +1 for loading indicator
              itemBuilder: (context, index) {
                if (index == stories.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final story = stories[index];
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
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
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
                  '加载失败',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(publicStoriesProvider.notifier).refresh();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLike(String storyId) {
    // TODO: 实现点赞功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('点赞成功')),
    );
  }
}
