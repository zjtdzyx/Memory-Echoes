import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';

class StoryDetailPage extends ConsumerWidget {
  final String storyId;
  const StoryDetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyDetailProvider(storyId));

    return Scaffold(
      appBar: AppBar(
        title: storyState.when(
          data: (story) => Text(story?.title ?? '故事详情'),
          loading: () => const Text('加载中...'),
          error: (_, __) => const Text('错误'),
        ),
        actions: [
          storyState.when(
            data: (story) {
              if (story == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.go('/edit-story/${story.id}'),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          )
        ],
      ),
      body: storyState.when(
        data: (story) {
          if (story == null) {
            return const Center(child: Text('未找到该故事'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  story.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '创建于: ${story.createdAt.toLocal()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                if (story.imageUrls.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: story.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(story.imageUrls[index]),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  story.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children:
                      story.tags.map((tag) => Chip(label: Text(tag))).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.mood),
                    const SizedBox(width: 8),
                    Text(story.mood.toString().split('.').last),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('发生错误: $err')),
      ),
    );
  }
}
