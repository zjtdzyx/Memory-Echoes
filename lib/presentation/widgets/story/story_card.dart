import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (story.imageUrls != null && story.imageUrls!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: story.imageUrls!.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (story.mood != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getMoodColor(story.mood!).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getMoodText(story.mood!),
                        style: TextStyle(
                          color: _getMoodColor(story.mood!),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    story.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatReadableDate(story.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: onLike,
                          ),
                          Text(story.likedBy.length.toString()),
                          if (onEdit != null || onDelete != null)
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  onEdit?.call();
                                } else if (value == 'delete') {
                                  onDelete?.call();
                                }
                              },
                              itemBuilder: (context) => [
                                if (onEdit != null)
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('编辑'),
                                  ),
                                if (onDelete != null)
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('删除'),
                                  ),
                              ],
                            ),
                        ],
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
}

Color _getMoodColor(StoryMood mood) {
  switch (mood) {
    case StoryMood.happy:
      return Colors.amber;
    case StoryMood.sad:
      return Colors.blueGrey;
    case StoryMood.adventurous:
      return Colors.deepOrange;
    case StoryMood.mysterious:
      return Colors.purple;
    case StoryMood.romantic:
      return Colors.pink;
    case StoryMood.humorous:
      return Colors.green;
  }
}

IconData _getMoodIcon(StoryMood mood) {
  switch (mood) {
    case StoryMood.happy:
      return Icons.sentiment_very_satisfied;
    case StoryMood.sad:
      return Icons.sentiment_very_dissatisfied;
    case StoryMood.adventurous:
      return Icons.explore_outlined;
    case StoryMood.mysterious:
      return Icons.question_mark;
    case StoryMood.romantic:
      return Icons.favorite_border;
    case StoryMood.humorous:
      return Icons.emoji_emotions_outlined;
  }
}

String _getMoodText(StoryMood mood) {
  switch (mood) {
    case StoryMood.happy:
      return '开心';
    case StoryMood.sad:
      return '难过';
    case StoryMood.adventurous:
      return '冒险';
    case StoryMood.mysterious:
      return '神秘';
    case StoryMood.romantic:
      return '浪漫';
    case StoryMood.humorous:
      return '幽默';
  }
}
