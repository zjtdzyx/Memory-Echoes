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
      ref.read(authProvider.notifier).signInWithEmail(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) => context.go('/home'),
        orElse: () {},
      );
    });

    final authState = ref.watch(authProvider);

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
                          gradient: LinearGradient(
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
                            Icon(
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
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '记忆回响',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.darkBrown,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Memory Echoes',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.richBrown.withOpacity(0.8),
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
                        color: AppTheme.richBrown.withOpacity(0.8),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // 登录表单卡片
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightCream,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.warmShadow,
                    border: Border.all(
                      color: AppTheme.primaryOrange.withOpacity(0.2),
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
                                  color: AppTheme.primaryOrange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
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
                                  color: AppTheme.primaryOrange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
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
                                shadowColor: AppTheme.primaryOrange.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: authState.maybeWhen(
                                loading: () => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                authenticated: (_) => const Icon(Icons.check, size: 24),
                                orElse: () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
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
                            child: Text(
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
                    color: AppTheme.primaryOrange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryOrange.withOpacity(0.1),
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
                        child: Text(
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
}
