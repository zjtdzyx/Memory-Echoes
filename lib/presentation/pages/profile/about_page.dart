import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        backgroundColor: AppTheme.lightCream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.darkBrown,
          ),
        ),
        title: Text(
          '关于我们',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用信息卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryOrange,
                    AppTheme.accentOrange,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.warmShadow,
              ),
              child: Column(
                children: [
                  // 应用图标
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '记忆回响',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Memory Echoes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 应用介绍
            _buildSectionCard(
              title: '应用介绍',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '记忆回响是一款温暖的记忆记录应用，致力于帮助用户记录、整理和分享人生中的美好时光。',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.richBrown.withValues(alpha: 0.9),
                      fontFamily: 'Georgia',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '通过AI技术，我们让每个人都能轻松地创作属于自己的故事，并将这些珍贵的回忆编织成完整的人生传记。',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.richBrown.withValues(alpha: 0.9),
                      fontFamily: 'Georgia',
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 核心功能
            _buildSectionCard(
              title: '核心功能',
              icon: Icons.star_outline,
              child: Column(
                children: [
                  _buildFeatureItem(
                    Icons.chat_bubble_outline,
                    'AI智能对话',
                    '与AI助手对话，轻松记录生活点滴',
                  ),
                  _buildFeatureItem(
                    Icons.auto_stories,
                    '故事创作',
                    '支持文字、图片、语音多种形式记录',
                  ),
                  _buildFeatureItem(
                    Icons.person_outline,
                    '传记生成',
                    'AI自动整理故事，生成个人传记',
                  ),
                  _buildFeatureItem(
                    Icons.share_outlined,
                    '分享交流',
                    '与朋友分享美好回忆，发现他人故事',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 开发团队
            _buildSectionCard(
              title: '开发团队',
              icon: Icons.group_outlined,
              child: Column(
                children: [
                  Text(
                    '我们是一群热爱生活、珍视回忆的开发者。我们相信每个人的故事都值得被记录和传承。',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.richBrown.withValues(alpha: 0.9),
                      fontFamily: 'Georgia',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: AppTheme.errorRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '用心打造，用爱传递',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 联系方式
            _buildSectionCard(
              title: '联系我们',
              icon: Icons.contact_support_outlined,
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.email_outlined,
                    '邮箱',
                    'support@memoryechoes.com',
                    () {
                      // TODO: 打开邮箱应用
                    },
                  ),
                  _buildContactItem(
                    Icons.language,
                    '官网',
                    'www.memoryechoes.com',
                    () {
                      // TODO: 打开网页
                    },
                  ),
                  _buildContactItem(
                    Icons.feedback_outlined,
                    '反馈',
                    '意见建议',
                    () {
                      context.go('/help-feedback');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 法律信息
            _buildSectionCard(
              title: '法律信息',
              icon: Icons.gavel_outlined,
              child: Column(
                children: [
                  _buildLegalItem(
                    '隐私政策',
                    '了解我们如何保护您的隐私',
                    () {
                      // TODO: 打开隐私政策页面
                    },
                  ),
                  _buildLegalItem(
                    '服务条款',
                    '使用应用前请仔细阅读',
                    () {
                      // TODO: 打开服务条款页面
                    },
                  ),
                  _buildLegalItem(
                    '开源许可',
                    '查看第三方开源库信息',
                    () {
                      // TODO: 打开开源许可页面
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 版权信息
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '© 2024 Memory Echoes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '让每个回忆都有回响',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.richBrown.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryOrange,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkBrown,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.richBrown.withValues(alpha: 0.8),
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.richBrown.withValues(alpha: 0.8),
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryOrange,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalItem(String title, String description, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.richBrown.withValues(alpha: 0.8),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryOrange,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
