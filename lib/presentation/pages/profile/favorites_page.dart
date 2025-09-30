import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        backgroundColor: AppTheme.lightCream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.darkBrown,
          ),
        ),
        title: const Text(
          '收藏夹',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: 实现搜索功能
            },
            icon: const Icon(
              Icons.search,
              color: AppTheme.primaryOrange,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: 实现更多操作
            },
            icon: const Icon(
              Icons.more_vert,
              color: AppTheme.primaryOrange,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.richBrown.withValues(alpha: 0.6),
          indicatorColor: AppTheme.primaryOrange,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Georgia',
          ),
          tabs: const [
            Tab(text: '故事'),
            Tab(text: '传记'),
            Tab(text: '收藏集'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStoriesTab(),
          _buildBiographiesTab(),
          _buildCollectionsTab(),
        ],
      ),
    );
  }

  Widget _buildStoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5, // 示例数据
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.lightCream,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.softShadow,
            border: Border.all(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.3),
                    AppTheme.accentOrange.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: AppTheme.primaryOrange,
                size: 24,
              ),
            ),
            title: Text(
              '童年的夏天 ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBrown,
                fontFamily: 'Georgia',
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '那个夏天，蝉鸣声声，我们在老槐树下度过了最美好的时光...',
                  style: TextStyle(
                    color: AppTheme.richBrown.withValues(alpha: 0.8),
                    fontFamily: 'Georgia',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '2天前收藏',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.richBrown.withValues(alpha: 0.6),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_horiz,
                color: AppTheme.primaryOrange,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    // TODO: 实现分享功能
                    break;
                  case 'remove':
                    // TODO: 实现取消收藏功能
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, color: AppTheme.primaryOrange),
                      SizedBox(width: 12),
                      Text('分享'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: AppTheme.errorRed),
                      SizedBox(width: 12),
                      Text('取消收藏'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: 跳转到故事详情页
            },
          ),
        );
      },
    );
  }

  Widget _buildBiographiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3, // 示例数据
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.lightCream,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.softShadow,
            border: Border.all(
              color: AppTheme.accentOrange.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentOrange.withValues(alpha: 0.3),
                    AppTheme.primaryOrange.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppTheme.accentOrange,
                size: 24,
              ),
            ),
            title: Text(
              '李明的人生传记 ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBrown,
                fontFamily: 'Georgia',
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '一个普通人的不平凡人生，记录了从童年到成年的点点滴滴...',
                  style: TextStyle(
                    color: AppTheme.richBrown.withValues(alpha: 0.8),
                    fontFamily: 'Georgia',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1周前收藏',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.richBrown.withValues(alpha: 0.6),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_horiz,
                color: AppTheme.accentOrange,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    // TODO: 实现分享功能
                    break;
                  case 'remove':
                    // TODO: 实现取消收藏功能
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, color: AppTheme.accentOrange),
                      SizedBox(width: 12),
                      Text('分享'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: AppTheme.errorRed),
                      SizedBox(width: 12),
                      Text('取消收藏'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: 跳转到传记详情页
            },
          ),
        );
      },
    );
  }

  Widget _buildCollectionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 4, // 示例数据
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.lightCream,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.softShadow,
            border: Border.all(
              color: AppTheme.infoBlue.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.infoBlue.withValues(alpha: 0.3),
                    AppTheme.successGreen.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.folder_outlined,
                color: AppTheme.infoBlue,
                size: 24,
              ),
            ),
            title: Text(
              '童年回忆集 ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBrown,
                fontFamily: 'Georgia',
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '收集了关于童年的美好回忆，包含12个故事和3个传记片段',
                  style: TextStyle(
                    color: AppTheme.richBrown.withValues(alpha: 0.8),
                    fontFamily: 'Georgia',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.infoBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${15 + index} 项内容',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.infoBlue,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '创建于 ${index + 1} 个月前',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.richBrown.withValues(alpha: 0.6),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_horiz,
                color: AppTheme.infoBlue,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // TODO: 实现编辑收藏集功能
                    break;
                  case 'share':
                    // TODO: 实现分享功能
                    break;
                  case 'delete':
                    // TODO: 实现删除收藏集功能
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: AppTheme.infoBlue),
                      SizedBox(width: 12),
                      Text('编辑'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, color: AppTheme.primaryOrange),
                      SizedBox(width: 12),
                      Text('分享'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outlined, color: AppTheme.errorRed),
                      SizedBox(width: 12),
                      Text('删除'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: 跳转到收藏集详情页
            },
          ),
        );
      },
    );
  }
}
