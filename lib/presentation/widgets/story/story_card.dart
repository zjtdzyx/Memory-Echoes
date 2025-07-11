import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/story_entity.dart';
import '../../../domain/enums/story_mood.dart';
import '../../../core/utils/date_utils.dart';

class StoryCard extends StatelessWidget {
  final StoryEntity story;
  final bool showAuthor;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StoryCard({
    super.key,
    required this.story,
    this.showAuthor = false,
    this.onTap,
    this.onLike,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片预览
            if (story.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: story.imageUrls.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          story.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null || onDelete != null)
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                onEdit?.call();
                                break;
                              case 'delete':
                                onDelete?.call();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            if (onEdit != null)
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
                            if (onDelete != null)
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
                  
                  const SizedBox(height: 8),
                  
                  // 内容预览
                  Text(
                    story.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 标签
                  if (story.tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: story.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
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
                  
                  const SizedBox(height: 12),
                  
                  // 底部信息
                  Row(
                    children: [
                      // 情感标识
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getMoodColor(story.mood).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
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
                      
                      // 点赞按钮
                      if (onLike != null)
                        InkWell(
                          onTap: onLike,
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '0', // 这里应该从story实体获取点赞数
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      const SizedBox(width: 8),
                      
                      // 时间
                      Text(
                        formatDate(story.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
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
      case StoryMood.adventurous:
        return Colors.deepOrange;
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
