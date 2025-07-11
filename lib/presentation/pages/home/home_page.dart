import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('记忆回响'),
        actions: [
          authState.when(
            authenticated: (user) => Row(
              children: [
                CircleAvatar(
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child:
                      user.photoURL == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 8),
                Text(user.displayName ?? '用户'),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                )
              ],
            ),
            initial: () => const SizedBox(),
            loading: () => const CircularProgressIndicator(),
            unauthenticated: (_) => TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('登录'),
            ),
            error: (message) => Tooltip(
              message: message,
              child: const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/create-story'),
              child: const Text('创建新的记忆'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/stories'),
              child: const Text('查看我的记忆'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/social-square'),
              child: const Text('社交广场'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/ai-chat'),
              child: const Text('与AI对话'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/settings'),
              child: const Text('设置'),
            ),
          ],
        ),
      ),
    );
  }
}
