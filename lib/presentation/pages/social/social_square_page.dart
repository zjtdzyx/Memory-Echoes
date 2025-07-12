import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';
import 'package:memory_echoes/presentation/widgets/story/story_card.dart';
import 'package:memory_echoes/presentation/widgets/common/empty_state.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';
import 'package:memory_echoes/core/services/share_service.dart';

class SocialSquarePage extends ConsumerWidget {
  const SocialSquarePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicStoriesState = ref.watch(publicStoriesProvider);

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
                  '社交广场',
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
                            Icons.people,
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
                            Icons.favorite,
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
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () => ShareService.shareAppInvitation(),
                    ),
                  ),
                ),
              ],
            ),

            // 故事列表
            publicStoriesState.when(
              data: (stories) {
                if (stories.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyState(
                      message: '还没有人分享故事\n成为第一个分享温暖回忆的人吧！',
                      icon: Icons.people_outline,
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final story = stories[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.lightCream,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppTheme.warmShadow,
                              border: Border.all(
                                color: AppTheme.primaryOrange.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 故事内容
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: StoryCard(
                                    story: story,
                                    showAuthor: true,
                                    onTap: () =>
                                        context.push('/story/${story.id}'),
                                  ),
                                ),

                                // 互动按钮
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange
                                        .withOpacity(0.05),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // 点赞按钮
                                      _buildActionButton(
                                        icon: Icons.favorite_border,
                                        label: '0',
                                        onTap: () => _handleLike(story.id),
                                      ),

                                      const SizedBox(width: 20),

                                      // 评论按钮
                                      _buildActionButton(
                                        icon: Icons.comment_outlined,
                                        label: '0',
                                        onTap: () => _handleComment(story.id),
                                      ),

                                      const Spacer(),

                                      // 分享按钮
                                      _buildActionButton(
                                        icon: Icons.share,
                                        label: '分享',
                                        onTap: () =>
                                            ShareService.shareStory(story),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: stories.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorRed,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '加载失败',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(publicStoriesProvider),
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryOrange,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLike(String? storyId) {
    // TODO: 实现点赞功能
    print('点赞故事: $storyId');
  }

  void _handleComment(String? storyId) {
    // TODO: 实现评论功能
    print('评论故事: $storyId');
  }
}
