import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class HelpFeedbackPage extends ConsumerStatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  ConsumerState<HelpFeedbackPage> createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends ConsumerState<HelpFeedbackPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _feedbackController.dispose();
    _emailController.dispose();
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
          '帮助与反馈',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
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
            Tab(text: '帮助中心'),
            Tab(text: '意见反馈'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHelpTab(),
          _buildFeedbackTab(),
        ],
      ),
    );
  }

  Widget _buildHelpTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightCream,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.softShadow,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索帮助内容...',
                hintStyle: TextStyle(
                  color: AppTheme.richBrown.withValues(alpha: 0.6),
                  fontFamily: 'Georgia',
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.primaryOrange,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 常见问题
          const Text(
            '常见问题',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 16),

          ..._buildFAQItems(),

          const SizedBox(height: 32),

          // 功能指南
          const Text(
            '功能指南',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 16),

          ..._buildGuideItems(),

          const SizedBox(height: 32),

          // 联系我们
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryOrange.withValues(alpha: 0.1),
                  AppTheme.accentOrange.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      '联系我们',
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
                  '如果您没有找到想要的答案，可以通过以下方式联系我们：',
                  style: TextStyle(
                    color: AppTheme.richBrown.withValues(alpha: 0.8),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: 打开邮箱
                        },
                        icon: const Icon(Icons.email_outlined),
                        label: const Text('发送邮件'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryOrange,
                          side: const BorderSide(color: AppTheme.primaryOrange),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _tabController.animateTo(1);
                        },
                        icon: const Icon(Icons.feedback_outlined),
                        label: const Text('在线反馈'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                        ),
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

  Widget _buildFeedbackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 反馈类型选择
          const Text(
            '反馈类型',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFeedbackTypeChip('功能建议', Icons.lightbulb_outlined),
              _buildFeedbackTypeChip('问题反馈', Icons.bug_report_outlined),
              _buildFeedbackTypeChip('界面优化', Icons.palette_outlined),
              _buildFeedbackTypeChip('其他', Icons.more_horiz),
            ],
          ),

          const SizedBox(height: 24),

          // 反馈内容
          const Text(
            '详细描述',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightCream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _feedbackController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: '请详细描述您遇到的问题或建议...',
                hintStyle: TextStyle(
                  color: AppTheme.richBrown.withValues(alpha: 0.6),
                  fontFamily: 'Georgia',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 联系邮箱
          const Text(
            '联系邮箱（可选）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBrown,
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightCream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: '请输入您的邮箱地址',
                hintStyle: TextStyle(
                  color: AppTheme.richBrown.withValues(alpha: 0.6),
                  fontFamily: 'Georgia',
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppTheme.primaryOrange,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 提交按钮
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                _submitFeedback();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '提交反馈',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 提示信息
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.infoBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.infoBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.infoBlue,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '我们会认真对待每一条反馈，通常在1-3个工作日内回复。',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.infoBlue,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFAQItems() {
    final faqs = [
      {
        'question': '如何创建我的第一个故事？',
        'answer': '点击首页的"创建故事"按钮，或者通过"对话"功能与AI聊天来生成故事。您可以输入文字、上传图片或录制语音来记录您的回忆。'
      },
      {
        'question': '什么是AI传记功能？',
        'answer': 'AI传记功能可以根据您创建的多个故事，自动生成一份完整的个人传记。AI会分析您的故事内容，按时间线整理并生成连贯的人生叙述。'
      },
      {
        'question': '我的数据安全吗？',
        'answer': '我们非常重视您的隐私和数据安全。所有数据都经过加密存储，您可以随时控制内容的公开程度，也可以选择完全私密保存。'
      },
      {
        'question': '如何分享我的故事？',
        'answer': '在故事详情页点击分享按钮，您可以选择分享到社交媒体、发送给朋友，或者生成分享链接。您也可以设置故事为公开，让其他用户发现。'
      },
    ];

    return faqs.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)).toList();
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBrown,
            fontFamily: 'Georgia',
          ),
        ),
        iconColor: AppTheme.primaryOrange,
        collapsedIconColor: AppTheme.primaryOrange,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: AppTheme.richBrown.withValues(alpha: 0.8),
                fontFamily: 'Georgia',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGuideItems() {
    final guides = [
      {
        'title': '新手入门指南',
        'description': '了解如何开始使用记忆回响',
        'icon': Icons.play_circle_outline,
      },
      {
        'title': '故事创作技巧',
        'description': '学习如何写出精彩的故事',
        'icon': Icons.edit_outlined,
      },
      {
        'title': 'AI对话使用指南',
        'description': '掌握与AI对话的技巧',
        'icon': Icons.chat_bubble_outline,
      },
      {
        'title': '隐私设置说明',
        'description': '了解如何保护您的隐私',
        'icon': Icons.security_outlined,
      },
    ];

    return guides.map((guide) => _buildGuideItem(
      guide['title']! as String,
      guide['description']! as String,
      guide['icon']! as IconData,
    )).toList();
  }

  Widget _buildGuideItem(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryOrange,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBrown,
            fontFamily: 'Georgia',
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: AppTheme.richBrown.withValues(alpha: 0.8),
            fontFamily: 'Georgia',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.primaryOrange,
          size: 16,
        ),
        onTap: () {
          // TODO: 跳转到具体指南页面
        },
      ),
    );
  }

  Widget _buildFeedbackTypeChip(String label, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        // TODO: 处理反馈类型选择
      },
      backgroundColor: AppTheme.lightCream,
      selectedColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryOrange,
      labelStyle: const TextStyle(
        color: AppTheme.darkBrown,
        fontFamily: 'Georgia',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入反馈内容'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    // TODO: 实现提交反馈逻辑
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('反馈提交成功，感谢您的建议！'),
        backgroundColor: AppTheme.successGreen,
      ),
    );

    _feedbackController.clear();
    _emailController.clear();
  }
}
