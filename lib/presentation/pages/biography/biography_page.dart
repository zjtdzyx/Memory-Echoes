import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/story_provider.dart';
import '../../widgets/biography/biography_generator.dart';
import '../../widgets/common/empty_state.dart';

class BiographyPage extends ConsumerWidget {
  const BiographyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI传记生成'),
      ),
      body: authState.maybeWhen(
        authenticated: (user) {
          final storiesAsync = ref.watch(userStoriesProvider(user.uid));
          return storiesAsync.when(
            data: (stories) {
              if (stories.isEmpty) {
                return const EmptyState(
                  icon: Icons.history_edu_outlined,
                  title: '故事太少啦',
                  subtitle: '多记录一些回忆，才能生成更精彩的传记哦',
                );
              }
              return BiographyGenerator(
                stories: stories,
                userId: user.uid,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
          );
        },
        orElse: () {
          Future.microtask(() => context.go('/login'));
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
