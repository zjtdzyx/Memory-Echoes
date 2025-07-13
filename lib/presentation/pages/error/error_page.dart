import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_theme.dart';

class ErrorPage extends StatelessWidget {
  final String? errorMessage;
  final String? errorCode;

  const ErrorPage({
    super.key,
    this.errorMessage,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopNavigation(context),
            
            // 错误内容
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 错误图标动画
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryOrange.withOpacity(0.1),
                                    AppTheme.accentOrange.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                  color: AppTheme.primaryOrange.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.sentiment_dissatisfied,
                                size: 60,
                                color: AppTheme.primaryOrange.withOpacity(0.8),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 错误代码
                      if (errorCode != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryOrange.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            errorCode!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // 主要错误信息
                      Text(
                        _getErrorTitle(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Georgia',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 错误描述
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          errorMessage ?? _getDefaultErrorMessage(),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.richBrown.withOpacity(0.8),
                            height: 1.5,
                            fontFamily: 'Georgia',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // 操作按钮
                      Column(
                        children: [
                          // 返回首页按钮
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryOrange,
                                  AppTheme.accentOrange,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryOrange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => context.go('/home'),
                              icon: const Icon(Icons.home, size: 20),
                              label: const Text(
                                '返回首页',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // 重试按钮
                          Container(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // 刷新当前页面
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.refresh,
                                size: 20,
                                color: AppTheme.primaryOrange,
                              ),
                              label: Text(
                                '重新尝试',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryOrange,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppTheme.primaryOrange,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 帮助文本
                      Text(
                        '如果问题持续存在，请联系我们的客服团队',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.richBrown.withOpacity(0.6),
                          fontFamily: 'Georgia',
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildTopNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo区域
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryOrange.withOpacity(0.2),
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
          ),
          
          const Spacer(),
          
          // 返回按钮
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppTheme.primaryOrange,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorTitle() {
    if (errorCode == '404') {
      return '页面走丢了';
    } else if (errorCode == '500') {
      return '服务器开小差了';
    } else if (errorCode == 'network') {
      return '网络连接异常';
    } else {
      return '出了点小问题';
    }
  }

  String _getDefaultErrorMessage() {
    if (errorCode == '404') {
      return '抱歉，您访问的页面不存在或已被移除。\n让我们一起回到温暖的首页，继续您的记忆之旅吧！';
    } else if (errorCode == '500') {
      return '服务器正在休息，我们正在努力修复。\n请稍后再试，或者先去看看其他精彩的故事吧！';
    } else if (errorCode == 'network') {
      return '网络连接似乎有些不稳定。\n请检查您的网络连接，然后重新尝试。';
    } else {
      return '遇到了一个意外的问题，但别担心！\n我们会尽快解决，让您继续享受美好的记忆时光。';
    }
  }
}
