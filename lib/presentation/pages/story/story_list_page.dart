import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';
import 'package:memory_echoes/presentation/widgets/story/story_card.dart';
import 'package:memory_echoes/presentation/widgets/common/empty_state.dart';

class StoryListPage extends ConsumerWidget {
  const StoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesState = ref.watch(storyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的记忆'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/create-story'),
          ),
        ],
      ),
      body: storiesState.when(
        data: (stories) {
          if (stories.isEmpty) {
            return const EmptyState(
              message: '你还没有创建任何故事，开始记录你的第一个记忆吧！',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return StoryCard(story: stories[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('加载故事失败: $error'),
        ),
      ),
    );
  }
}
