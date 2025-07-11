import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/data/models/story_model.dart';
import '../../../domain/enums/story_mood.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import '../../../core/constants/app_theme.dart';

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
  
  StoryMood _mood = StoryMood.neutral;
  final List<String> _tags = [];
  final List<String> _imageUrls = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authProvider);
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

  @override
  Widget build(BuildContext context) {
    // 检查用户登录状态
    ref.watch(authProvider).whenOrNull(
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
                      color: Colors.white.withOpacity(0.2),
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
                  // 表单卡片
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightCream,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.warmShadow,
                      border: Border.all(
                        color: AppTheme.primaryOrange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 表单标题
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.create,
                                    color: AppTheme.primaryOrange,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '记录你的美好回忆',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkBrown,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // 标题输入框
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: '记忆标题',
                                hintText: '给这段记忆起个温暖的名字...',
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.title,
                                    color: AppTheme.primaryOrange,
                                    size: 20,
                                  ),
                                ),
                              ),
                              validator: (value) => 
                                  value?.isEmpty == true ? '请输入记忆标题' : null,
                            ),

                            const SizedBox(height: 24),

                            // 内容输入框
                            TextFormField(
                              controller: _contentController,
                              decoration: InputDecoration(
                                labelText: '记忆内容',
                                hintText: '详细描述这段美好的回忆...',
                                alignLabelWithHint: true,
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.description,
                                    color: AppTheme.primaryOrange,
                                    size: 20,
                                  ),
                                ),
                              ),
                              maxLines: 8,
                              minLines: 4,
                              validator: (value) => 
                                  value?.isEmpty == true ? '请输入记忆内容' : null,
                            ),

                            const SizedBox(height: 24),

                            // 心情选择
                            Text(
                              '当时的心情',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryOrange.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.primaryOrange.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonFormField<StoryMood>(
                                value: _mood,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                items: StoryMood.values.map((mood) {
                                  return DropdownMenuItem(
                                    value: mood,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getMoodIcon(mood),
                                          color: _getMoodColor(mood),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _getMoodText(mood),
                                          style: TextStyle(
                                            color: AppTheme.darkBrown,
                                            fontFamily: 'Georgia',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _mood = value;
                                    });
                                  }
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 标签输入框
                            TextFormField(
                              controller: _tagsController,
                              decoration: InputDecoration(
                                labelText: '标签',
                                hintText: '用逗号分隔，如：童年,快乐,家人',
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.local_offer,
                                    color: AppTheme.primaryOrange,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // 提交按钮
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.save_alt),
                                label: const Text(
                                  '保存记忆',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryOrange,
                                  foregroundColor: Colors.white,
                                  elevation: 6,
                                  shadowColor: AppTheme.primaryOrange.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 温馨提示
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryOrange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppTheme.primaryOrange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '记录生活中的美好瞬间，让每一份回忆都成为珍贵的宝藏',
                            style: TextStyle(
                              color: AppTheme.richBrown,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ),
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

  Color _getMoodColor(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return AppTheme.warningAmber;
      case StoryMood.sad:
        return AppTheme.infoBlue;
      case StoryMood.nostalgic:
        return AppTheme.secondaryOrange;
      case StoryMood.peaceful:
        return AppTheme.successGreen;
      case StoryMood.excited:
        return AppTheme.primaryOrange;
      case StoryMood.neutral:
        return AppTheme.richBrown;
      case StoryMood.adventurous:
        return AppTheme.errorRed;
    }
  }

  IconData _getMoodIcon(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return Icons.sentiment_very_satisfied;
      case StoryMood.sad:
        return Icons.sentiment_dissatisfied;
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
