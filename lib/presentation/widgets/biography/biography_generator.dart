import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/story_entity.dart';
import '../../../domain/entities/biography_entity.dart';
import '../common/warm_card.dart';
import '../../providers/gemini_api_provider.dart';
import '../../services/share_service.dart';
import '../../providers/biography_repository_provider.dart';

class BiographyGenerator extends ConsumerStatefulWidget {
  final List<StoryEntity> stories;
  final String userId;

  const BiographyGenerator({
    super.key,
    required this.stories,
    required this.userId,
  });

  @override
  ConsumerState<BiographyGenerator> createState() => _BiographyGeneratorState();
}

class _BiographyGeneratorState extends ConsumerState<BiographyGenerator> {
  final List<String> _selectedStoryIds = [];
  BiographyTheme _selectedTheme = BiographyTheme.classic;
  bool _isGenerating = false;
  String? _generatedContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 故事选择
        WarmCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选择故事',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '选择要包含在传记中的故事（建议选择3-8个故事）',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: 16),

                // 故事列表
                ...widget.stories.map((story) {
                  final isSelected = _selectedStoryIds.contains(story.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedStoryIds.add(story.id ?? '');
                        } else {
                          _selectedStoryIds.remove(story.id ?? '');
                        }
                      });
                    },
                    title: Text(
                      story.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      story.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 主题选择
        WarmCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选择主题风格',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),

                // 主题选项
                ...BiographyTheme.values.map((theme) {
                  return RadioListTile<BiographyTheme>(
                    value: theme,
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        _selectedTheme = value!;
                      });
                    },
                    title: Text(_getThemeTitle(theme)),
                    subtitle: Text(_getThemeDescription(theme)),
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 生成按钮
        ElevatedButton(
          onPressed: _selectedStoryIds.isEmpty || _isGenerating
              ? null
              : _generateBiography,
          child: _isGenerating
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('AI 正在创作中...'),
                  ],
                )
              : Text('生成传记 (${_selectedStoryIds.length}个故事)'),
        ),

        // 生成结果
        if (_generatedContent != null) ...[
          const SizedBox(height: 20),
          WarmCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '你的专属传记',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _generatedContent!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareContent,
                          icon: const Icon(Icons.share),
                          label: const Text('分享'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _saveContent,
                          icon: const Icon(Icons.save),
                          label: const Text('保存'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getThemeTitle(BiographyTheme theme) {
    switch (theme) {
      case BiographyTheme.classic:
        return '经典风格';
      case BiographyTheme.modern:
        return '现代风格';
      case BiographyTheme.vintage:
        return '复古风格';
      case BiographyTheme.elegant:
        return '优雅风格';
    }
  }

  String _getThemeDescription(BiographyTheme theme) {
    switch (theme) {
      case BiographyTheme.classic:
        return '传统的叙述方式，温暖而正式';
      case BiographyTheme.modern:
        return '现代化的表达，简洁而生动';
      case BiographyTheme.vintage:
        return '怀旧的语调，充满诗意';
      case BiographyTheme.elegant:
        return '优雅的文笔，富有文学性';
    }
  }

  Future<void> _generateBiography() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final selectedStories = widget.stories
          .where((story) => _selectedStoryIds.contains(story.id ?? ''))
          .toList();

      final storyContents =
          selectedStories.map((story) => story.content).toList();
      final theme = _selectedTheme.name;

      // 使用Gemini API生成传记
      final geminiApiService = ref.read(geminiApiServiceProvider);
      final generatedContent =
          await geminiApiService.generateBiography(storyContents, theme);

      setState(() {
        _generatedContent = generatedContent;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('生成失败: $e')),
        );
      }
    }
  }

  void _shareContent() {
    if (_generatedContent != null) {
      ShareService.shareText(
        _generatedContent!,
        subject: '我的人生传记',
      );
    }
  }

  void _saveContent() async {
    if (_generatedContent == null) return;

    try {
      final selectedStories = widget.stories
          .where((story) => _selectedStoryIds.contains(story.id ?? ''))
          .toList();

      final biography = BiographyModel(
        userId: widget.userId,
        title: '我的人生传记',
        content: _generatedContent!,
        storyIds: _selectedStoryIds,
        theme: _selectedTheme,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final biographyRepository = ref.read(biographyRepositoryProvider);
      await biographyRepository.createBiography(biography);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('传记保存成功！')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }
}
