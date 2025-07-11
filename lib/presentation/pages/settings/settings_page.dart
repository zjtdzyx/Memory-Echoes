import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/warm_card.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../../domain/entities/user_entity.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: authState.maybeWhen(
        authenticated: (user) => _buildSettingsList(context, ref, user),
        orElse: () {
          Future.microtask(() => context.go('/login'));
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSettingsList(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 用户信息卡片
          WarmCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : 'U',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showEditProfileDialog(context, ref, user),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('编辑资料'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 应用设置
          WarmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '应用设置',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  title: '主题设置',
                  subtitle: '选择你喜欢的主题风格',
                  onTap: () => _showThemeDialog(context, ref),
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: '通知设置',
                  subtitle: '管理推送通知偏好',
                  onTap: () => _showNotificationSettings(context),
                ),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: '语言设置',
                  subtitle: '选择应用语言',
                  onTap: () => _showLanguageSettings(context),
                ),
                _SettingsTile(
                  icon: Icons.storage_outlined,
                  title: '存储管理',
                  subtitle: '管理本地存储和缓存',
                  onTap: () => _showStorageSettings(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 隐私与安全
          WarmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '隐私与安全',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.security_outlined,
                  title: '账户安全',
                  subtitle: '修改密码和安全设置',
                  onTap: () => _showSecuritySettings(context),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: '隐私设置',
                  subtitle: '控制数据分享和隐私选项',
                  onTap: () => _showPrivacySettings(context),
                ),
                _SettingsTile(
                  icon: Icons.backup_outlined,
                  title: '数据备份',
                  subtitle: '备份和恢复你的故事数据',
                  onTap: () => _showBackupSettings(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 帮助与支持
          WarmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '帮助与支持',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: '使用帮助',
                  subtitle: '查看使用指南和常见问题',
                  onTap: () => _showHelpCenter(context),
                ),
                _SettingsTile(
                  icon: Icons.feedback_outlined,
                  title: '意见反馈',
                  subtitle: '告诉我们你的想法和建议',
                  onTap: () => _showFeedback(context),
                ),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: '关于应用',
                  subtitle: '版本信息和开发团队',
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 退出登录按钮
          ElevatedButton.icon(
            onPressed: () => _showLogoutDialog(context, ref),
            icon: const Icon(Icons.logout),
            label: const Text('退出登录'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, user) {
    final nameController = TextEditingController(text: user.displayName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑资料'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '昵称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: 实现头像上传
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('更换头像'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 保存用户资料
              Navigator.of(context).pop();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('主题设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('跟随系统'),
              value: ThemeMode.system,
              groupValue: ThemeMode.light, // TODO: 从状态管理获取
              onChanged: (value) {
                // TODO: 更新主题设置
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('浅色模式'),
              value: ThemeMode.light,
              groupValue: ThemeMode.light,
              onChanged: (value) {
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('深色模式'),
              value: ThemeMode.dark,
              groupValue: ThemeMode.light,
              onChanged: (value) {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // TODO: 实现通知设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('通知设置功能开发中')),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    // TODO: 实现语言设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('语言设置功能开发中')),
    );
  }

  void _showStorageSettings(BuildContext context) {
    // TODO: 实现存储设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('存储管理功能开发中')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    // TODO: 实现安全设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('安全设置功能开发中')),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    // TODO: 实现隐私设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('隐私设置功能开发中')),
    );
  }

  void _showBackupSettings(BuildContext context) {
    // TODO: 实现备份设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据备份功能开发中')),
    );
  }

  void _showHelpCenter(BuildContext context) {
    // TODO: 实现帮助中心
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('帮助中心功能开发中')),
    );
  }

  void _showFeedback(BuildContext context) {
    // TODO: 实现意见反馈
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('意见反馈功能开发中')),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '记忆回响',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.auto_stories, size: 48),
      children: [
        const Text('一个温暖的记忆记录与分享应用'),
        const SizedBox(height: 16),
        const Text('让每一个美好的回忆都被珍藏'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authStateProvider.notifier).signOut();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
