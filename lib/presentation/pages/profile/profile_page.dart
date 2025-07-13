import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopNavigation(context, ref, authState),

            // 个人信息区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 用户信息卡片
                    _buildUserInfoCard(context, authState),

                    const SizedBox(height: 24),

                    // 功能菜单
                    _buildMenuSection(context),

                    const SizedBox(height: 24),

                    // 设置区域
                    _buildSettingsSection(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildTopNavigation(BuildContext context, WidgetRef ref, authState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo区域
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: AppTheme.primaryOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '记忆回响',
                    style: TextStyle(
                      color: AppTheme.darkBrown,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          Text(
            '我的',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, authState) {
    return authState.maybeWhen(
      authenticated: (user) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryOrange,
              AppTheme.secondaryOrange,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.warmShadow,
        ),
        child: Column(
          children: [
            // 头像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            // 用户名
            Text(
              user.displayName ?? '记忆收藏家',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Georgia',
              ),
            ),

            const SizedBox(height: 8),

            // 邮箱
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontFamily: 'Georgia',
              ),
            ),

            const SizedBox(height: 20),

            // 统计信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('故事', '12'),
                _buildStatItem('传记', '2'),
                _buildStatItem('回忆', '365'),
              ],
            ),
          ],
        ),
      ),
      orElse: () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.lightCream,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: AppTheme.primaryOrange.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              '未登录',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBrown,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '登录后体验完整功能',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.richBrown.withValues(alpha: 0.8),
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('立即登录'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.auto_stories,
            title: '我的故事',
            subtitle: '查看所有记录的故事',
            onTap: () => context.go('/stories'),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.auto_awesome,
            title: '我的传记',
            subtitle: 'AI生成的个人传记',
            onTap: () => context.go('/biography'),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.favorite,
            title: '收藏夹',
            subtitle: '收藏的精彩内容',
            onTap: () => context.go('/favorites'),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.share,
            title: '分享应用',
            subtitle: '推荐给朋友使用',
            onTap: () {
              // TODO: 实现分享功能
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: '设置',
            subtitle: '个性化你的体验',
            onTap: () => context.go('/settings'),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: '帮助与反馈',
            subtitle: '获取帮助或提供建议',
            onTap: () => context.go('/help'),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: '关于我们',
            subtitle: '了解记忆回响',
            onTap: () => context.go('/about'),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: '退出登录',
            subtitle: '安全退出当前账户',
            textColor: AppTheme.errorRed,
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (textColor ?? AppTheme.primaryOrange).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: textColor ?? AppTheme.primaryOrange,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
          color: textColor ?? AppTheme.darkBrown,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.richBrown.withValues(alpha: 0.8),
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '首页',
                isActive: false,
                onTap: () => context.go('/home'),
              ),
              _buildNavItem(
                context,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: '发现',
                isActive: false,
                onTap: () => context.go('/discover'),
              ),
              _buildNavItem(
                context,
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: '对话',
                isActive: false,
                onTap: () => context.go('/chat'),
              ),
              _buildNavItem(
                context,
                icon: Icons.auto_stories_outlined,
                activeIcon: Icons.auto_stories,
                label: '回忆',
                isActive: false,
                onTap: () => context.go('/stories'),
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                isActive: true,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryOrange.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppTheme.primaryOrange
                  : AppTheme.richBrown.withValues(alpha: 0.6),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? AppTheme.primaryOrange
                    : AppTheme.richBrown.withValues(alpha: 0.6),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '确认退出',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.darkBrown,
          ),
        ),
        content: Text(
          '确定要退出登录吗？',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.richBrown,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authStateProvider.notifier).signOut();
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}
