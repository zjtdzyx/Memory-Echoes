import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';
import 'package:memory_echoes/presentation/widgets/home/feature_card.dart';
import 'package:memory_echoes/presentation/widgets/home/story_preview_card.dart';
import 'package:memory_echoes/presentation/widgets/home/biography_preview_card.dart';
import 'package:memory_echoes/presentation/widgets/story/story_card.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // 根据认证状态选择合适的 provider
    final AsyncValue<List<StoryEntity>> recentStoriesState =
        authState.maybeWhen(
      authenticated: (user) => ref.watch(userRecentStoriesProvider(user.id)),
      orElse: () => ref.watch(recentStoriesProvider),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopNavigation(context, ref, authState),
            
            // 搜索框
            _buildSearchBar(context),
            
            // 主要内容
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 我的故事卡片组
                    _buildMyStoriesSection(context, recentStoriesState),
                    
                    const SizedBox(height: 24),
                    
                    // 我的传记卡片组
                    _buildMyBiographySection(context),
                    
                    const SizedBox(height: 24),
                    
                    // 快速开始卡片组
                    _buildQuickStartSection(context),
                    
                    const SizedBox(height: 24),
                    
                    // 他人的故事卡片组
                    _buildOthersStoriesSection(context),
                    
                    const SizedBox(height: 24),
                    
                    // 今日推荐
                    _buildTodayRecommendationSection(context),
                    
                    // 底部间距
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildTopNavigation(BuildContext context, WidgetRef ref, authState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo区域
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_stories,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '记忆回响',
                  style: TextStyle(
                    color: AppTheme.darkBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 通知按钮
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
            ),
            child: IconButton(
              onPressed: () => context.go('/notifications'),
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primaryOrange,
                    size: 24,
                  ),
                  // 红点提示
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 用户头像
          authState.maybeWhen(
            authenticated: (user) => GestureDetector(
              onTap: () => context.go('/profile'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(
                          Icons.person,
                          color: AppTheme.primaryOrange,
                          size: 24,
                        )
                      : null,
                ),
              ),
            ),
            orElse: () => GestureDetector(
              onTap: () => context.go('/login'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppTheme.primaryOrange,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => context.go('/search'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppTheme.richBrown.withValues(alpha: 0.5),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                '搜索故事、传记...',
                style: TextStyle(
                  color: AppTheme.richBrown.withValues(alpha: 0.5),
                  fontSize: 16,
                  fontFamily: 'Georgia',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.mic_outlined,
                  color: AppTheme.primaryOrange,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyStoriesSection(BuildContext context, AsyncValue<List<StoryEntity>> storiesState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      color: AppTheme.primaryOrange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '我的故事',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        '记录生活中的美好时光',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.richBrown.withValues(alpha: 0.7),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/stories'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '查看全部',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryOrange,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: storiesState.when(
              data: (stories) {
                if (stories.isEmpty) {
                  return _buildEmptyStoriesCard(context);
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCreateStoryCard(context);
                    }
                    final story = stories[index - 1];
                    return StoryPreviewCard(
                      story: story,
                      onTap: () => context.push('/story/${story.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorCard(context, error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyBiographySection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppTheme.accentOrange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '我的传记',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        'AI为你编织人生故事',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.richBrown.withValues(alpha: 0.7),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/biography'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '查看详情',
                      style: TextStyle(
                        color: AppTheme.accentOrange,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.accentOrange,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                BiographyPreviewCard(
                  title: '我的人生传记',
                  subtitle: '基于12个故事生成',
                  progress: 0.75,
                  imageUrl: '/placeholder.svg?height=120&width=160',
                  onTap: () => context.go('/biography'),
                ),
                BiographyPreviewCard(
                  title: '创建新传记',
                  subtitle: '选择故事开始创建',
                  isCreateCard: true,
                  onTap: () => context.go('/biography/create'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.flash_on,
                  color: AppTheme.successGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '快速开始',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  Text(
                    '开启你的记忆之旅',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.richBrown.withValues(alpha: 0.7),
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: '开始对话',
                  description: '与AI分享今天的故事',
                  icon: Icons.chat_bubble_outline,
                  onTap: () => context.go('/chat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FeatureCard(
                  title: '创建故事',
                  description: '记录美好时光',
                  icon: Icons.edit_outlined,
                  onTap: () => context.go('/story/create'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: '语音记录',
                  description: '用声音记录回忆',
                  icon: Icons.mic_outlined,
                  onTap: () => context.go('/voice-record'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FeatureCard(
                  title: '照片故事',
                  description: '让照片诉说故事',
                  icon: Icons.photo_camera_outlined,
                  onTap: () => context.go('/photo-story'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOthersStoriesSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.infoBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.explore_outlined,
                      color: AppTheme.infoBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '他人的故事',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        '发现更多温暖的回忆',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.richBrown.withValues(alpha: 0.7),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/discover'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '发现更多',
                      style: TextStyle(
                        color: AppTheme.infoBlue,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.infoBlue,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // 示例数据
              itemBuilder: (context, index) {
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightCream,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.softShadow,
                    border: Border.all(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 图片区域
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryOrange.withValues(alpha: 0.3),
                                AppTheme.accentOrange.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.photo_outlined,
                              color: AppTheme.primaryOrange,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      // 内容区域
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.person,
                                    size: 16,
                                    color: AppTheme.primaryOrange,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '匿名用户',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.richBrown.withValues(alpha: 0.7),
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.favorite_border,
                                  size: 16,
                                  color: AppTheme.primaryOrange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${12 + index}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryOrange,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '童年的夏天',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkBrown,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '那个夏天，蝉鸣声声，我们在老槐树下...',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.richBrown.withValues(alpha: 0.8),
                                fontFamily: 'Georgia',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayRecommendationSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.wb_sunny_outlined,
                  color: AppTheme.warningAmber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日推荐',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  Text(
                    '为你精选的温暖内容',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.richBrown.withValues(alpha: 0.7),
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.warningAmber.withValues(alpha: 0.1),
                  AppTheme.primaryOrange.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.warningAmber.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppTheme.warningAmber,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '记忆提示',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '今天是个记录回忆的好日子！不如分享一下最近发生的有趣事情，或者回忆一段美好的往事？',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.richBrown.withValues(alpha: 0.9),
                    fontFamily: 'Georgia',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/chat'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.warningAmber,
                          side: BorderSide(color: AppTheme.warningAmber),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('开始对话'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go('/story/create'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warningAmber,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('创建故事'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateStoryCard(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryOrange.withValues(alpha: 0.8),
            AppTheme.accentOrange.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/story/create'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '创建新故事',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Georgia',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '记录美好时光',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontFamily: 'Georgia',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStoriesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 48,
            color: AppTheme.primaryOrange.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            '还没有故事',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开始创建您的第一个故事吧！',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.richBrown.withValues(alpha: 0.7),
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/story/create'),
            child: const Text('创建故事'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorRed.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppTheme.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.errorRed,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.errorRed.withValues(alpha: 0.8),
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '首页',
                isActive: true,
                onTap: () => context.go('/home'),
              ),
              _buildNavItem(
                context,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: '发现',
                isActive: false,
                onTap: () => context.go('/discover'),
              ),
              _buildNavItem(
                context,
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: '对话',
                isActive: false,
                onTap: () => context.go('/chat'),
              ),
              _buildNavItem(
                context,
                icon: Icons.auto_stories_outlined,
                activeIcon: Icons.auto_stories,
                label: '回忆',
                isActive: false,
                onTap: () => context.go('/stories'),
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                isActive: false,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryOrange.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppTheme.primaryOrange
                  : AppTheme.richBrown.withValues(alpha: 0.6),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? AppTheme.primaryOrange
                    : AppTheme.richBrown.withValues(alpha: 0.6),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
