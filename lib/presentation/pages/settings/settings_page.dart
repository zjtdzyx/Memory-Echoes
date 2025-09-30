import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditingDisplayName = false;
  bool _isLoading = false;
  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      appBar: AppBar(
        title: Text(
          '个人设置',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.darkBrown,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.darkBrown),
      ),
      body: authState.maybeWhen(
        authenticated: (user) {
          // 初始化控制器
          if (_displayNameController.text.isEmpty) {
            _displayNameController.text = user.displayName ?? '';
          }
          if (_emailController.text.isEmpty) {
            _emailController.text = user.email;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户头像和基本信息卡片
                _buildProfileCard(user),

                const SizedBox(height: 24),

                // 账户设置
                _buildSectionTitle('账户设置'),
                const SizedBox(height: 16),
                _buildAccountSettings(user),

                const SizedBox(height: 32),

                // 安全设置
                _buildSectionTitle('安全设置'),
                const SizedBox(height: 16),
                _buildSecuritySettings(),

                const SizedBox(height: 32),

                // 应用设置
                _buildSectionTitle('应用设置'),
                const SizedBox(height: 16),
                _buildAppSettings(),

                const SizedBox(height: 32),

                // 退出登录
                _buildSignOutSection(),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryOrange,
          ),
        ),
        unauthenticated: () {
          Future.microtask(() => context.go('/login'));
          return const Center(
            child: Text(
              '请先登录',
              style: TextStyle(
                color: AppTheme.richBrown,
                fontFamily: 'Georgia',
              ),
            ),
          );
        },
        orElse: () => const SizedBox(),
      ),
    );
  }

  Widget _buildProfileCard(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          // 头像部分
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryOrange,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 47,
                  backgroundColor: AppTheme.warmCream,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppTheme.primaryOrange,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.warmShadow,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _showAvatarOptions,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 用户名显示/编辑
          if (_isEditingDisplayName)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _displayNameController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Georgia',
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: AppTheme.successGreen),
                  onPressed: _saveDisplayName,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.errorRed),
                  onPressed: () {
                    setState(() {
                      _isEditingDisplayName = false;
                      _displayNameController.text = user.displayName ?? '';
                    });
                  },
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.displayName ?? '未设置用户名',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                    fontFamily: 'Georgia',
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppTheme.primaryOrange,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditingDisplayName = true;
                    });
                  },
                ),
              ],
            ),

          const SizedBox(height: 8),

          Text(
            user.email,
            style: TextStyle(
              color: AppTheme.richBrown.withValues(alpha: 0.8),
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.darkBrown,
        fontFamily: 'Georgia',
      ),
    );
  }

  Widget _buildAccountSettings(user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.email_outlined,
            title: '邮箱地址',
            subtitle: user.email,
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.primaryOrange),
              onPressed: _showEmailChangeDialog,
            ),
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.verified_user_outlined,
            title: '账户验证',
            subtitle: user.emailVerified ? '已验证' : '未验证',
            trailing: user.emailVerified
                ? const Icon(Icons.check_circle, color: AppTheme.successGreen)
                : TextButton(
                    onPressed: _sendVerificationEmail,
                    child: const Text('发送验证邮件'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: '修改密码',
            subtitle: '定期更新密码以保护账户安全',
            trailing:
                const Icon(Icons.chevron_right, color: AppTheme.primaryOrange),
            onTap: _showPasswordChangeDialog,
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.security_outlined,
            title: '两步验证',
            subtitle: '增强账户安全性',
            trailing: Switch(
              value: false, // TODO: 实现两步验证状态
              onChanged: (value) {
                _showComingSoonDialog('两步验证功能即将推出');
              },
              activeColor: AppTheme.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: '推送通知',
            subtitle: '管理通知设置',
            trailing: Switch(
              value: true, // TODO: 实现通知状态管理
              onChanged: (value) {
                _showComingSoonDialog('通知设置功能即将推出');
              },
              activeColor: AppTheme.primaryOrange,
            ),
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.dark_mode_outlined,
            title: '深色模式',
            subtitle: '切换应用主题',
            trailing: Switch(
              value: false, // TODO: 实现主题切换
              onChanged: (value) {
                _showComingSoonDialog('深色模式即将推出');
              },
              activeColor: AppTheme.primaryOrange,
            ),
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.language_outlined,
            title: '语言设置',
            subtitle: '简体中文',
            trailing:
                const Icon(Icons.chevron_right, color: AppTheme.primaryOrange),
            onTap: () => _showComingSoonDialog('多语言支持即将推出'),
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.storage_outlined,
            title: '数据管理',
            subtitle: '清除缓存和本地数据',
            trailing:
                const Icon(Icons.chevron_right, color: AppTheme.primaryOrange),
            onTap: _showDataManagementDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: _buildSettingTile(
        icon: Icons.logout,
        title: '退出登录',
        subtitle: '退出当前账户',
        titleColor: AppTheme.errorRed,
        iconColor: AppTheme.errorRed,
        onTap: _showSignOutDialog,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.primaryOrange).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppTheme.primaryOrange,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppTheme.darkBrown,
          fontFamily: 'Georgia',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.richBrown.withValues(alpha: 0.7),
          fontFamily: 'Georgia',
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  // 头像选择选项
  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '选择头像',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  icon: Icons.camera_alt,
                  label: '拍照',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildAvatarOption(
                  icon: Icons.photo_library,
                  label: '相册',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                _buildAvatarOption(
                  icon: Icons.delete,
                  label: '移除',
                  onTap: _removeAvatar,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryOrange,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  // 选择图片
  void _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        // TODO: 实现图片上传到Firebase Storage
        _showComingSoonDialog('头像上传功能即将推出');
      }
    } catch (e) {
      _showErrorDialog('选择图片失败: $e');
    }
  }

  // 移除头像
  void _removeAvatar() {
    Navigator.pop(context);
    // TODO: 实现移除头像功能
    _showComingSoonDialog('移除头像功能即将推出');
  }

  // 保存显示名称
  void _saveDisplayName() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 实现更新显示名称
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络请求
      setState(() {
        _isEditingDisplayName = false;
        _isLoading = false;
      });
      _showSuccessDialog('用户名更新成功');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('更新用户名失败: $e');
    }
  }

  // 显示邮箱修改对话框
  void _showEmailChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '修改邮箱',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.darkBrown,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '新邮箱地址',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '当前密码',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonDialog('邮箱修改功能即将推出');
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  // 显示密码修改对话框
  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '修改密码',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.darkBrown,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '当前密码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '新密码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '确认新密码',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonDialog('密码修改功能即将推出');
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  // 发送验证邮件
  void _sendVerificationEmail() {
    _showComingSoonDialog('邮箱验证功能即将推出');
  }

  // 显示数据管理对话框
  void _showDataManagementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '数据管理',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.darkBrown,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('缓存大小: 约 5.2 MB'),
            SizedBox(height: 8),
            Text('本地数据: 约 12.8 MB'),
            SizedBox(height: 16),
            Text(
              '清除数据后，您需要重新登录，但云端数据不会丢失。',
              style: TextStyle(
                color: AppTheme.richBrown,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonDialog('数据清理功能即将推出');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningAmber,
            ),
            child: const Text('清除数据'),
          ),
        ],
      ),
    );
  }

  // 显示退出登录确认对话框
  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '退出登录',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.darkBrown,
          ),
        ),
        content: const Text(
          '确定要退出当前账户吗？',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.richBrown,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(authStateProvider.notifier).signOut();
                if (mounted) {
                  context.go('/login');
                }
              } catch (e) {
                _showErrorDialog('退出登录失败: $e');
              }
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

  // 显示即将推出对话框
  void _showComingSoonDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '即将推出',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.darkBrown,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.richBrown,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  // 显示成功对话框
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successGreen),
            SizedBox(width: 8),
            Text(
              '成功',
              style: TextStyle(
                fontFamily: 'Georgia',
                color: AppTheme.darkBrown,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.richBrown,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 显示错误对话框
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.error, color: AppTheme.errorRed),
            SizedBox(width: 8),
            Text(
              '错误',
              style: TextStyle(
                fontFamily: 'Georgia',
                color: AppTheme.darkBrown,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Georgia',
            color: AppTheme.richBrown,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
