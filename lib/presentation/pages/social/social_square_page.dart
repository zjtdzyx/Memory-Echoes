import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/story/story_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../providers/story_provider.dart';

class SocialSquarePage extends ConsumerWidget {
  const SocialSquarePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(publicStoriesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('社交广场'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: 刷新数据
              // ignore: unused_result
              ref.refresh(publicStoriesProvider);
            },
          ),
        ],
      ),
      body: storiesAsync.when(
        data: (stories) {
          if (stories.isEmpty) {
            return const EmptyState(
              message: '暂无公开故事\n成为第一个分享温暖回忆的人吧',
              icon: Icons.public_outlined,
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
                  showAuthor: true,
                  onTap: () => context.push('/story/${story.id}'),
                  onLike: () => _handleLike(context, ref, story.id),
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
                  // ignore: unused_result
                  ref.refresh(publicStoriesProvider);
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLike(BuildContext context, WidgetRef ref, String? storyId) {
    // TODO: 实现点赞功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('点赞成功')),
    );
  }
}
