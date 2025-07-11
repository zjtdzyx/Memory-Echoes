import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: authState.maybeWhen(
        authenticated: (user) => ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('账户信息'),
              subtitle: Text(user.email),
            ),
            ListTile(
              leading: const Icon(Icons.display_settings),
              title: const Text('显示名称'),
              subtitle: Text(user.displayName ?? '未设置'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: () async {
                await ref.read(authProvider.notifier).signOut();
                context.go('/login');
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        unauthenticated: () {
          // Should not happen if routed correctly, but good practice to handle.
          Future.microtask(() => context.go('/login'));
          return const Center(child: Text('请先登录.'));
        },
        orElse: () => const SizedBox(),
      ),
    );
  }
}
