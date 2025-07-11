import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/warm_card.dart';
import '../../widgets/story/story_editor.dart';
import '../../providers/auth_provider.dart';
import '../../../domain/usecases/story_usecases.dart';
import '../../../dependency_injection.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPublic = false;
  bool _isLoading = false;
  List<String> _selectedImages = [];
  String? _audioUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('创建故事'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题输入
            WarmCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '故事标题',
                    hintText: '为你的故事起个温暖的名字',
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 内容编辑器
            StoryEditor(
              contentController: _contentController,
              onImagesChanged: (images) {
                setState(() {
                  _selectedImages = images;
                });
              },
              onAudioChanged: (audioUrl) {
                setState(() {
                  _audioUrl = audioUrl;
                });
              },
            ),

            const SizedBox(height: 16),

            // 设置选项
            WarmCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '故事设置',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('公开分享'),
                      subtitle: const Text('允许其他用户在社交广场看到这个故事'),
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
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

  Future<void> _handleSave() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写标题和内容')),
      );
      return;
    }

    final authState = ref.read(authStateProvider);
    if (authState is Authenticated) {
      ref.read(createStoryUseCaseProvider).call(
            userId: authState.user.uid,
            title: _titleController.text,
            content: _contentController.text,
            imageUrls: [], // TODO: Handle image upload and get URLs
            isPublic: _isPublic,
          );
      context.pop();
    }
  }
}
