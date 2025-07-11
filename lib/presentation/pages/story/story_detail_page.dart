import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/story_entity.dart';
import '../../../domain/enums/story_mood.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/story_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/warm_card.dart';

class StoryDetailPage extends ConsumerWidget {
  final String storyId;
  const StoryDetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyDetailProvider(storyId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.maybeWhen(
        authenticated: (user) => user.uid, orElse: () => null);

    return storyAsync.when(
      data: (story) {
        final isOwner = story.userId == currentUserId;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background:
                      story.imageUrls != null && story.imageUrls!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: story.imageUrls!.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) =>
                                  Container(color: Colors.grey[200]),
                            )
                          : Container(color: Colors.grey[200]),
                ),
                actions: [
                  if (isOwner)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => context.push('/story/$storyId/edit'),
                    ),
                  if (isOwner)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteDialog(context, ref, storyId),
                    ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => _shareStory(context, story),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatReadableDate(story.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Divider(height: 32),
                          if (story.mood != null) ...[
                            Row(
                              children: [
                                Icon(
                                  _getMoodIcon(story.mood!),
                                  color: _getMoodColor(story.mood!),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getMoodText(story.mood!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: _getMoodColor(story.mood!),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (story.imageUrls != null &&
                              story.imageUrls!.length > 1) ...[
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: story.imageUrls!.length - 1,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: story.imageUrls![index + 1],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          SelectableText(
                            story.content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(height: 1.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String storyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('这个故事将永远消失，确定要删除吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete logic in provider
              Navigator.of(context).pop();
              context.pop(); // Go back from detail page
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _shareStory(BuildContext context, StoryEntity story) {
    Share.share('快来看看我的故事《${story.title}》！ ${story.content}');
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
