import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class BiographyPreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? progress;
  final String? imageUrl;
  final bool isCreateCard;
  final VoidCallback? onTap;

  const BiographyPreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.progress,
    this.imageUrl,
    this.isCreateCard = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: isCreateCard
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentOrange.withValues(alpha: 0.8),
                  AppTheme.primaryOrange.withValues(alpha: 0.8),
                ],
              )
            : null,
        color: isCreateCard ? null : AppTheme.lightCream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.warmShadow,
        border: Border.all(
          color: isCreateCard 
              ? Colors.transparent 
              : AppTheme.accentOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isCreateCard
                ? _buildCreateContent()
                : _buildBiographyContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateContent() {
    return Column(
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
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Georgia',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontFamily: 'Georgia',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBiographyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 图标和标题
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppTheme.accentOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.richBrown.withValues(alpha: 0.7),
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 进度条
        if (progress != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '完成度',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.richBrown.withValues(alpha: 0.7),
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                '${(progress! * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentOrange,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.accentOrange.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentOrange),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
        ],
        
        const Spacer(),
        
        // 底部按钮
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.accentOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            progress != null ? '查看详情' : '开始创建',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentOrange,
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
