import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_theme.dart';
import '../../../data/models/story_model.dart';
import '../../../domain/enums/story_mood.dart';
import '../../providers/story_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../dependency_injection.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  StoryMood _mood = StoryMood.happy;
  List<String> _tags = [];
  List<String> _imageUrls = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final authState = ref.read(authStateProvider);
    final userId = authState.whenOrNull(authenticated: (user) => user.id);

    if (userId == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileUploadService = ref.read(fileUploadServiceProvider);
      final newImageUrls =
          await fileUploadService.pickAndUploadMultipleImages(userId);

      setState(() {
        _imageUrls.addAll(newImageUrls);
        _isUploading = false;
      });

      if (newImageUrls.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('成功上传 ${newImageUrls.length} 张图片'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('图片上传失败: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authStateProvider);
      final userId = authState.whenOrNull(authenticated: (user) => user.id);

      if (userId != null) {
        // 处理标签
        if (_tagsController.text.isNotEmpty) {
          _tags.clear();
          _tags.addAll(_tagsController.text.split(',').map((e) => e.trim()));
        }

        final newStory = StoryModel(
          userId: userId,
          title: _titleController.text,
          content: _contentController.text,
          mood: _mood,
          tags: _tags,
          imageUrls: _imageUrls,
          createdAt: DateTime.now(),
          isPublic: false,
        );

        try {
          await ref
              .read(storyListProvider(userId).notifier)
              .createStory(newStory);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('记忆创建成功！'),
                backgroundColor: AppTheme.successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            context.pop();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('创建失败: $e'),
                backgroundColor: AppTheme.errorRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('用户未登录，无法创建故事'),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 检查用户登录状态
    ref.watch(authStateProvider).whenOrNull(
      unauthenticated: () {
        Future.microtask(() => context.go('/login'));
      },
    );

    return Scaffold(
      body: Container(
        decoration: AppTheme.subtleGradientDecoration,
        child: CustomScrollView(
          slivers: [
            // 温暖的AppBar
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  '创建新的记忆',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                background: Container(
                  decoration: AppTheme.warmGradientDecoration,
                  child: Stack(
                    children: [
                      // 装饰性图案
                      Positioned(
                        right: -20,
                        top: 40,
                        child: Opacity(
                          opacity: 0.2,
                          child: Icon(
                            Icons.edit_note,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: 20,
                        child: Opacity(
                          opacity: 0.15,
                          child: Icon(
                            Icons.extension,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.save, color: Colors.white),
                      onPressed: _submit,
                    ),
                  ),
                ),
              ],
            ),

            // 表单内容
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题输入
                        _buildTitleInput(),
                        const SizedBox(height: 20),

                        // 内容输入
                        _buildContentInput(),
                        const SizedBox(height: 20),

                        // 心情选择
                        _buildMoodSelector(),
                        const SizedBox(height: 20),

                        // 标签输入
                        _buildTagsInput(),
                        const SizedBox(height: 20),

                        // 图片上传
                        _buildImageSection(),
                        const SizedBox(height: 30),
                      ],
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

  Widget _buildTitleInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: '记忆标题',
          hintText: '给这段记忆起个温暖的名字...',
          prefixIcon: Icon(Icons.title, color: AppTheme.primaryOrange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '请输入记忆标题';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
      ),
      child: TextFormField(
        controller: _contentController,
        maxLines: 8,
        decoration: InputDecoration(
          labelText: '记忆内容',
          hintText: '分享你的故事，让温暖的回忆永远流传...',
          prefixIcon: Icon(Icons.edit_note, color: AppTheme.primaryOrange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          alignLabelWithHint: true,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '请输入记忆内容';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mood, color: AppTheme.primaryOrange),
              const SizedBox(width: 8),
              Text(
                '选择心情',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: StoryMood.values.map((mood) {
              final isSelected = _mood == mood;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _mood = mood;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getMoodColor(mood).withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? _getMoodColor(mood)
                          : Colors.grey.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getMoodIcon(mood),
                        size: 20,
                        color: isSelected ? _getMoodColor(mood) : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getMoodText(mood),
                        style: TextStyle(
                          color: isSelected ? _getMoodColor(mood) : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
      ),
      child: TextFormField(
        controller: _tagsController,
        decoration: InputDecoration(
          labelText: '标签',
          hintText: '用逗号分隔多个标签，如：家庭,快乐,成长',
          prefixIcon: Icon(Icons.tag, color: AppTheme.primaryOrange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library, color: AppTheme.primaryOrange),
              const SizedBox(width: 8),
              Text(
                '添加图片',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _isUploading ? null : _pickImages,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_photo_alternate),
                label: Text(_isUploading ? '上传中...' : '选择图片'),
              ),
            ],
          ),
          if (_imageUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Color _getMoodColor(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return Colors.amber;
      case StoryMood.sad:
        return Colors.blue;
      case StoryMood.nostalgic:
        return Colors.purple;
      case StoryMood.peaceful:
        return Colors.green;
      case StoryMood.excited:
        return Colors.orange;
      case StoryMood.neutral:
        return Colors.grey;
      case StoryMood.adventurous:
        return Colors.red;
    }
  }

  IconData _getMoodIcon(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return Icons.sentiment_very_satisfied;
      case StoryMood.sad:
        return Icons.sentiment_very_dissatisfied;
      case StoryMood.nostalgic:
        return Icons.auto_awesome;
      case StoryMood.peaceful:
        return Icons.spa;
      case StoryMood.excited:
        return Icons.celebration;
      case StoryMood.neutral:
        return Icons.sentiment_neutral;
      case StoryMood.adventurous:
        return Icons.explore;
    }
  }

  String _getMoodText(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return '开心';
      case StoryMood.sad:
        return '难过';
      case StoryMood.nostalgic:
        return '怀念';
      case StoryMood.peaceful:
        return '平静';
      case StoryMood.excited:
        return '兴奋';
      case StoryMood.neutral:
        return '平常';
      case StoryMood.adventurous:
        return '冒险';
    }
  }
}
