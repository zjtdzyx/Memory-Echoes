import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/story_entity.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/date_utils.dart';

class StoryPreviewCard extends StatelessWidget {
  final StoryEntity story;
  final VoidCallback? onTap;

  const StoryPreviewCard({
    super.key,
    required this.story,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
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
                  child: story.imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: story.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryOrange.withValues(alpha: 0.2),
                                  AppTheme.accentOrange.withValues(alpha: 0.2),
                                ],
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryOrange,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryOrange.withValues(alpha: 0.2),
                                  AppTheme.accentOrange.withValues(alpha: 0.2),
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
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryOrange.withValues(alpha: 0.2),
                                AppTheme.accentOrange.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.auto_stories_outlined,
                              color: AppTheme.primaryOrange,
                              size: 32,
                            ),
                          ),
                        ),
                ),
              ),
              
              // 内容区域
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Georgia',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          story.content,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.richBrown.withValues(alpha: 0.8),
                            fontFamily: 'Georgia',
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDate(story.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.richBrown.withValues(alpha: 0.6),
                              fontFamily: 'Georgia',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              story.tags.isNotEmpty ? story.tags.first : '回忆',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
