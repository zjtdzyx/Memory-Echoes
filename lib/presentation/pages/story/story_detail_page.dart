import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/common/warm_card.dart';
import '../../../domain/entities/story_entity.dart';
import '../../../dependency_injection.dart';

class StoryDetailPage extends ConsumerWidget {
  final String storyId;

  const StoryDetailPage({
    super.key,
    required this.storyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<StoryEntity>(
        future: ref.read(storyRepositoryProvider).getStoryById(storyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '加载失败',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final story = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    story.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  background: story.imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: story.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareStory(story),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          // TODO: 导航到编辑页面
                          break;
                        case 'delete':
                          _showDeleteDialog(context, story.id);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text('编辑'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outlined),
                            SizedBox(width: 8),
                            Text('删除'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 内容
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 故事信息
                      WarmCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 标签和情感
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getMoodColor(story.mood).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getMoodIcon(story.mood),
                                          size: 16,
                                          color: _getMoodColor(story.mood),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _getMoodText(story.mood),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: _getMoodColor(story.mood),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatDate(story.createdAt),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // 故事内容
                              Text(
                                story.content,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.8,
                                  fontSize: 16,
                                ),
                              ),

                              // 标签
                              if (story.tags.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: story.tags.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        tag,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // 图片展示
                      if (story.imageUrls.length > 1) ...[
                        const SizedBox(height: 16),
                        WarmCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '相关图片',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: story.imageUrls.length - 1,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: story.imageUrls[index + 1],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: Theme.of(context).colorScheme.surfaceVariant,
                                          child: const Icon(Icons.image_outlined),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: Theme.of(context).colorScheme.surfaceVariant,
                                          child: const Icon(Icons.broken_image_outlined),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // 音频播放器
                      if (story.audioUrl != null) ...[
                        const SizedBox(height: 16),
                        WarmCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.audiotrack,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '故事录音',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    // TODO: 播放音频
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getMoodColor(StoryMood mood) {
    switch (mood) {
      case StoryMood.happy:
        return Colors.orange;
      case StoryMood.sad:
        return Colors.blue;
      case StoryMood.nostalgic:
        return Colors.purple;
      case StoryMood.peaceful:
        return Colors.green;
      case StoryMood.excited:
        return Colors.red;
      case StoryMood.neutral:
        return Colors.grey;
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
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  void _shareStory(StoryEntity story) {
    Share.share(
      '${story.title}\n\n${story.content}\n\n来自记忆回响App',
      subject: story.title,
    );
  }

  void _showDeleteDialog(BuildContext context, String storyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除故事'),
        content: const Text('确定要删除这个故事吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 实现删除功能
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
