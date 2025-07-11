import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/warm_card.dart';
import '../../widgets/story/story_editor.dart';
import '../../../domain/entities/story_entity.dart';
import '../../../dependency_injection.dart';

class EditStoryPage extends ConsumerStatefulWidget {
  final String storyId;

  const EditStoryPage({
    super.key,
    required this.storyId,
  });

  @override
  ConsumerState<EditStoryPage> createState() => _EditStoryPageState();
}

class _EditStoryPageState extends ConsumerState<EditStoryPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPublic = false;
  bool _isLoading = false;
  List<String> _selectedImages = [];
  String? _audioUrl;
  StoryEntity? _originalStory;

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadStory() async {
    try {
      final story =
          await ref.read(storyRepositoryProvider).getStoryById(widget.storyId);
      setState(() {
        _originalStory = story;
        _titleController.text = story.title;
        _contentController.text = story.content;
        _isPublic = story.isPublic;
        if (story.imageUrls != null) {
          _selectedImages = List.from(story.imageUrls!);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_originalStory == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('编辑故事'),
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

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedStory = _originalStory!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imageUrls: _selectedImages,
        isPublic: _isPublic,
        updatedAt: DateTime.now(),
      );

      await ref.read(storyRepositoryProvider).updateStory(updatedStory);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('故事更新成功')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
