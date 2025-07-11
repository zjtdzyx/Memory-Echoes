import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/chat_input.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('AI 陪伴'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
            },
          ),
          if (chatState.messages.length > 1)
            IconButton(
              icon: const Icon(Icons.auto_stories),
              onPressed: () => _showGenerateStoryDialog(),
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: 显示更多选项
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 聊天消息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI 正在思考...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

          // 输入区域
          ChatInput(
            onSendMessage: _handleSendMessage,
            isLoading: chatState.isLoading,
          ),
        ],
      ),
    );
  }

  void _handleSendMessage(String content) {
    final authState = ref.read(authStateProvider);
    authState.maybeWhen(
      authenticated: (user) {
        ref.read(chatProvider.notifier).sendMessage(content, user.id);
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
      builder: (context) => AlertDialog(
        title: const Text('生成故事'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('根据这段对话生成一个温暖的故事'),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '故事标题',
                hintText: '为你的故事起个名字',
              ),
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
              if (titleController.text.trim().isNotEmpty) {
                final authState = ref.read(authStateProvider);
                authState.maybeWhen(
                  authenticated: (user) {
                    ref.read(chatProvider.notifier).generateStoryFromChat(
                          user.id,
                          titleController.text.trim(),
                        );
                  },
                  orElse: () {},
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('生成'),
          ),
        ],
      ),
    );
  }
}
