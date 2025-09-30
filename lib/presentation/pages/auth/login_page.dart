import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import 'package:memory_echoes/presentation/providers/auth_state.dart';
import 'package:memory_echoes/core/constants/app_theme.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(authStateProvider.notifier).signInWithEmail(_email, _password);
    }
  }

  void _signInWithGoogle() {
    ref.read(authStateProvider.notifier).signInWithGoogle();
  }

  void _signInWithApple() {
    ref.read(authStateProvider.notifier).signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) => context.go('/home'),
        orElse: () {},
      );
    });

    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.subtleGradientDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // 应用图标和标题
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryOrange,
                              AppTheme.accentOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: AppTheme.warmShadow,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 书本图标
                            const Icon(
                              Icons.menu_book_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                            // 拼图装饰
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Icon(
                                Icons.extension,
                                size: 20,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '记忆回响',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.darkBrown,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Memory Echoes',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.richBrown.withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // 欢迎文字
                Text(
                  '欢迎回来',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  '继续你的记忆之旅',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.richBrown.withValues(alpha: 0.8),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // 社交登录按钮
                _buildSocialLoginButtons(authState),

                const SizedBox(height: 32),

                // 分割线
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '或使用邮箱登录',
                        style: TextStyle(
                          color: AppTheme.richBrown.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 登录表单卡片
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightCream,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.warmShadow,
                    border: Border.all(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // 邮箱输入框
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: '邮箱地址',
                              hintText: '请输入您的邮箱',
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.email_outlined,
                                  color: AppTheme.primaryOrange,
                                  size: 20,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return '请输入有效的邮箱地址';
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value!,
                          ),

                          const SizedBox(height: 24),

                          // 密码输入框
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: '密码',
                              hintText: '请输入您的密码',
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.lock_outline,
                                  color: AppTheme.primaryOrange,
                                  size: 20,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return '密码长度不能少于6位';
                              }
                              return null;
                            },
                            onSaved: (value) => _password = value!,
                          ),

                          const SizedBox(height: 32),

                          // 登录按钮
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: authState.maybeWhen(
                                loading: () => null,
                                authenticated: (_) => null,
                                orElse: () => _submit,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryOrange,
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor: AppTheme.primaryOrange
                                    .withValues(alpha: 0.4),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              child: authState.maybeWhen(
                                loading: () => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                authenticated: (_) =>
                                    const Icon(Icons.check, size: 24),
                                orElse: () => const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '登录',
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
                          ),

                          const SizedBox(height: 20),

                          // 忘记密码
                          TextButton(
                            onPressed: () {
                              // TODO: 实现忘记密码功能
                            },
                            child: const Text(
                              '忘记密码？',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 注册链接
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '还没有账号？',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.richBrown,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text(
                          '立即注册',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons(AuthState authState) {
    return Column(
      children: [
        // Google 登录按钮
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: authState.maybeWhen(
              loading: () => null,
              authenticated: (_) => null,
              orElse: () => _signInWithGoogle,
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.darkBrown,
              side: BorderSide(
                color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              shadowColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '使用 Google 登录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkBrown,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Apple 登录按钮
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: authState.maybeWhen(
              loading: () => null,
              authenticated: (_) => null,
              orElse: () => _signInWithApple,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkBrown,
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: AppTheme.darkBrown.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.apple,
                      size: 20,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '使用 Apple 登录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
