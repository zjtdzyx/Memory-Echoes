import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/story/story_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../providers/story_provider.dart';
import '../../providers/auth_provider.dart';

class StoryListPage extends ConsumerStatefulWidget {
  const StoryListPage({super.key});

  @override
  ConsumerState<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends ConsumerState<StoryListPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    if (authState is! _Authenticated) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final storiesAsync = ref.watch(userStoriesProvider(authState.user.id));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('我的故事'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/story/create'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userStoriesProvider(authState.user.id));
        },
        child: storiesAsync.when(
          data: (stories) {
            if (stories.isEmpty) {
              return const EmptyState(
                icon: Icons.auto_stories_outlined,
                title: '还没有故事',
                subtitle: '开始记录你的第一个温暖回忆吧',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StoryCard(
                    story: story,
                    onTap: () => context.push('/story/${story.id}'),
                    onEdit: () => context.push('/story/${story.id}/edit'),
                    onDelete: () => _showDeleteDialog(story.id),
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
                    ref.invalidate(userStoriesProvider(authState.user.id));
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

  void _showDeleteDialog(String storyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除故事'),
        content: const Text('确定要删除这个故事吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 实现删除功能
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
