import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.subtleGradientDecoration,
        child: CustomScrollView(
          slivers: [
            // 温暖的渐变AppBar
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: AppTheme.warmGradientDecoration,
                  child: Stack(
                    children: [
                      // 装饰性书本图案
                      Positioned(
                        right: -30,
                        top: 50,
                        child: Opacity(
                          opacity: 0.2,
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 120,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        bottom: 30,
                        child: Opacity(
                          opacity: 0.15,
                          child: Icon(
                            Icons.auto_stories,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // 拼图碎片装饰
                      Positioned(
                        right: 60,
                        bottom: 80,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.extension,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 120,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.extension,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // 主标题
                      Positioned(
                        left: 24,
                        bottom: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '记忆回响',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Georgia',
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Memory Echoes',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                authState.maybeWhen(
                  authenticated: (user) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              backgroundImage: user.photoURL != null
                                  ? NetworkImage(user.photoURL!)
                                  : null,
                              child: user.photoURL == null
                                  ? const Icon(Icons.person, 
                                      color: Colors.white, size: 20)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.more_vert, 
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                      onSelected: (value) {
                        if (value == 'logout') {
                          ref.read(authProvider.notifier).signOut();
                        } else if (value == 'settings') {
                          context.go('/settings');
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings, 
                                  color: AppTheme.primaryOrange),
                              const SizedBox(width: 12),
                              const Text('设置'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, 
                                  color: AppTheme.errorRed),
                              const SizedBox(width: 12),
                              const Text('退出登录'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  unauthenticated: () => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('登录'),
                    ),
                  ),
                  orElse: () => const SizedBox(),
                ),
              ],
            ),

            // 主要内容区域
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 温暖的欢迎卡片
                  authState.maybeWhen(
                    authenticated: (user) => Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color: AppTheme.lightCream,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppTheme.warmShadow,
                        border: Border.all(
                          color: AppTheme.primaryOrange.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.waving_hand,
                              color: AppTheme.primaryOrange,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '你好，${user.displayName ?? '朋友'}！',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: AppTheme.darkBrown,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '今天想记录什么美好的回忆呢？',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.richBrown.withOpacity(0.8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    orElse: () => const SizedBox(),
                  ),

                  // 功能标题
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_stories,
                          color: AppTheme.primaryOrange,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '开始你的记忆之旅',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // 主要功能卡片网格
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _WarmFeatureCard(
                        title: '创建记忆',
                        subtitle: '记录当下美好',
                        icon: Icons.edit_note,
                        colors: [AppTheme.primaryOrange, AppTheme.accentOrange],
                        onTap: () => context.go('/story/create'),
                      ),
                      _WarmFeatureCard(
                        title: 'AI 对话',
                        subtitle: '智能陪伴聊天',
                        icon: Icons.psychology,
                        colors: [AppTheme.infoBlue, AppTheme.infoBlue.withOpacity(0.8)],
                        onTap: () => context.go('/chat'),
                      ),
                      _WarmFeatureCard(
                        title: '我的记忆',
                        subtitle: '回顾珍贵时光',
                        icon: Icons.photo_library,
                        colors: [AppTheme.successGreen, AppTheme.successGreen.withOpacity(0.8)],
                        onTap: () => context.go('/stories'),
                      ),
                      _WarmFeatureCard(
                        title: '社交广场',
                        subtitle: '分享温暖故事',
                        icon: Icons.people_alt,
                        colors: [AppTheme.warningAmber, AppTheme.secondaryOrange],
                        onTap: () => context.go('/social'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 更多功能标题
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.extension,
                          color: AppTheme.primaryOrange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '更多精彩功能',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // 次要功能列表
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightCream,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Column(
                      children: [
                        _WarmListTile(
                          icon: Icons.search,
                          title: '搜索记忆',
                          subtitle: '快速找到想要的内容',
                          onTap: () => context.go('/search'),
                        ),
                        Divider(
                          height: 1,
                          color: AppTheme.primaryOrange.withOpacity(0.1),
                        ),
                        _WarmListTile(
                          icon: Icons.auto_awesome,
                          title: '生成传记',
                          subtitle: 'AI 帮你整理人生故事',
                          onTap: () => context.go('/biography'),
                        ),
                        Divider(
                          height: 1,
                          color: AppTheme.primaryOrange.withOpacity(0.1),
                        ),
                        _WarmListTile(
                          icon: Icons.settings,
                          title: '个人设置',
                          subtitle: '个性化你的体验',
                          onTap: () => context.go('/settings'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 底部装饰
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: AppTheme.primaryOrange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '用心记录，温暖回响',
                            style: TextStyle(
                              color: AppTheme.richBrown,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 温暖的功能卡片
class _WarmFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const _WarmFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.warmShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontFamily: 'Georgia',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 温暖的列表项
class _WarmListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _WarmListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryOrange,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
          color: AppTheme.darkBrown,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.richBrown.withOpacity(0.8),
          fontFamily: 'Georgia',
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.primaryOrange,
      ),
      onTap: onTap,
    );
  }
}
