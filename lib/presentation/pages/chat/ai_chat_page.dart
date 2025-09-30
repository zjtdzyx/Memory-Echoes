import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/chat/message_bubble.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_theme.dart';

class AiChatPage extends ConsumerStatefulWidget {  
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 在页面初始化时加载聊天历史
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateProvider);
      authState.maybeWhen(
        authenticated: (user) {
          ref.read(chatProvider.notifier).loadChatHistory(user.id);
        },
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB), // 温暖的奶油色背景
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopNavigation(context, ref, authState),

            // 聊天内容区域
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F2), // 更浅的奶油色
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 聊天消息列表
                    Expanded(
                      child: chatState.messages.isEmpty
                          ? _buildWelcomeMessage()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(20),
                              itemCount: chatState.messages.length,
                              itemBuilder: (context, index) {
                                final message = chatState.messages[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: MessageBubble(message: message),
                                );
                              },
                            ),
                    ),

                    // 加载指示器
                    if (chatState.isLoading)
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryOrange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'AI 正在思考...',
                              style: TextStyle(
                                color:
                                    AppTheme.richBrown.withValues(alpha: 0.8),
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ],
                        ),
                      ),

                    // 增强的聊天输入区域
                    _buildEnhancedChatInput(),
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
        color: const Color(0xFFFAF7F2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.08),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: AppTheme.primaryOrange,
                    size: 20,
                  ),
                  SizedBox(width: 8),
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

          // 清除聊天历史按钮
          authState.maybeWhen(
            authenticated: (user) => IconButton(
              icon: const Icon(
                Icons.clear_all,
                color: AppTheme.primaryOrange,
                size: 24,
              ),
              onPressed: () => _showClearChatDialog(user.id),
              tooltip: '清除聊天历史',
            ),
            orElse: () => const SizedBox(),
          ),

          // 用户头像
          authState.maybeWhen(
            authenticated: (user) => GestureDetector(
              onTap: () => context.go('/profile'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(
                          Icons.person,
                          color: AppTheme.primaryOrange,
                          size: 24,
                        )
                      : null,
                ),
              ),
            ),
            orElse: () => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI 图标
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology,
              size: 48,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 32),

          // 欢迎消息气泡
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F1EB),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: const Text(
              '今天你的故事是什么？',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.darkBrown,
                fontWeight: FontWeight.w600,
                fontFamily: 'Georgia',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '与AI分享你的记忆，让它帮你记录美好时光',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.richBrown.withValues(alpha: 0.7),
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedChatInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F1EB),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 主输入区域
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // 文本输入框
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '输入你的故事...',
                      hintStyle: TextStyle(
                        color: AppTheme.richBrown.withValues(alpha: 0.5),
                        fontFamily: 'Georgia',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    maxLines: null,
                    minLines: 1,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      color: AppTheme.darkBrown,
                    ),
                  ),
                ),

                // 语音输入按钮
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.mic,
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    onPressed: () {
                      // TODO: 实现语音输入
                    },
                  ),
                ),

                // 发送按钮
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      _handleSendMessage(_messageController.text);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 功能按钮行
          Row(
            children: [
              // 文件上传
              _buildActionButton(
                icon: Icons.attach_file,
                label: '文件',
                onTap: () {
                  // TODO: 实现文件上传
                },
              ),

              const SizedBox(width: 12),

              // 图片上传
              _buildActionButton(
                icon: Icons.image,
                label: '图片',
                onTap: () {
                  // TODO: 实现图片上传
                },
              ),

              const Spacer(),

              // 生成故事按钮
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryOrange,
                      AppTheme.accentOrange,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showGenerateStoryDialog();
                  },
                  icon: const Icon(Icons.auto_stories, size: 18),
                  label: const Text('生成故事'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryOrange,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.08),
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
                isActive: true,
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
                isActive: false,
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
              ? AppTheme.primaryOrange.withValues(alpha: 0.15)
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

  void _handleSendMessage(String content) {
    if (content.trim().isEmpty) return;

    final authState = ref.read(authStateProvider);
    authState.maybeWhen(
      authenticated: (user) {
        ref.read(chatProvider.notifier).sendMessage(content, user.id);
        _messageController.clear();
      },
      orElse: () {},
    );
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showGenerateStoryDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final chatState = ref.watch(chatProvider);

          return AlertDialog(
            backgroundColor: const Color(0xFFFAF7F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              '生成故事',
              style: TextStyle(
                color: AppTheme.darkBrown,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '根据这段对话生成一个温暖的故事',
                  style: TextStyle(
                    color: AppTheme.richBrown.withValues(alpha: 0.8),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '故事标题',
                    hintText: '为你的故事起个名字',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ),
                ),
                if (chatState.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            chatState.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (chatState.isLoading) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '正在生成故事...',
                        style: TextStyle(
                          color: AppTheme.richBrown.withValues(alpha: 0.8),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: chatState.isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: AppTheme.richBrown.withValues(alpha: 0.7),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: chatState.isLoading
                    ? null
                    : () {
                        if (titleController.text.trim().isNotEmpty) {
                          final authState = ref.read(authStateProvider);
                          authState.maybeWhen(
                            authenticated: (user) {
                              ref
                                  .read(chatProvider.notifier)
                                  .generateStoryFromChat(
                                    user.id,
                                    titleController.text.trim(),
                                  );
                            },
                            orElse: () {},
                          );

                          // 延迟关闭对话框，等待操作完成
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (context.mounted && !chatState.isLoading) {
                              Navigator.of(context).pop();
                              // 显示成功提示
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('故事生成成功！'),
                                  backgroundColor: AppTheme.primaryOrange,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('生成'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearChatDialog(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '确认清除聊天历史',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '确定要清除与AI的聊天历史吗？这将删除所有与AI的对话。',
          style: TextStyle(
            color: AppTheme.richBrown.withValues(alpha: 0.8),
            fontFamily: 'Georgia',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: TextStyle(
                color: AppTheme.richBrown.withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat(userId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('聊天历史已清除！'),
                  backgroundColor: AppTheme.primaryOrange,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }
}
