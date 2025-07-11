import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/warm_card.dart';
import '../../widgets/home/feature_card.dart';
import '../../providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    if (authState is! _Authenticated) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = authState.user;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('你好，${user.displayName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 欢迎卡片
            WarmCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '记录每一个温暖时刻',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '让AI陪伴你整理珍贵的回忆，创作属于你的人生故事',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/chat'),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('开始对话'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 功能网格
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                FeatureCard(
                  icon: Icons.auto_stories,
                  title: '我的故事',
                  subtitle: '查看和管理你的故事',
                  color: Colors.blue,
                  onTap: () => context.push('/stories'),
                ),
                FeatureCard(
                  icon: Icons.public,
                  title: '社交广场',
                  subtitle: '发现其他人的温暖故事',
                  color: Colors.green,
                  onTap: () => context.push('/social'),
                ),
                FeatureCard(
                  icon: Icons.menu_book,
                  title: '我的传记',
                  subtitle: 'AI为你生成专属传记',
                  color: Colors.purple,
                  onTap: () => context.push('/biography'),
                ),
                FeatureCard(
                  icon: Icons.add_circle_outline,
                  title: '创建故事',
                  subtitle: '记录新的美好回忆',
                  color: Colors.orange,
                  onTap: () => context.push('/story/create'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 快速统计
            WarmCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '我的记录',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            icon: Icons.auto_stories,
                            label: '故事数量',
                            value: '12', // TODO: 从状态管理获取真实数据
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            icon: Icons.favorite,
                            label: '获得点赞',
                            value: '48',
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            icon: Icons.calendar_today,
                            label: '记录天数',
                            value: '30',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
