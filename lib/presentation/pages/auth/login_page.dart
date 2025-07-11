import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';

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
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          context.go('/home');
        },
        unauthenticated: (message) {
          if (message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
        error: (message) {
          if (message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
      );
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // 欢迎标题
              Text(
                '欢迎回来',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '继续你的记忆之旅',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // 登录表单
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // 邮箱输入框
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '邮箱',
                            prefixIcon: Icon(Icons.email),
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

                        const SizedBox(height: 16),

                        // 密码输入框
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '密码',
                            prefixIcon: Icon(Icons.lock),
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

                        const SizedBox(height: 24),

                        // 登录按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authState.when(
                              loading: () => null,
                              initial: () => _submit,
                              authenticated: (_) => null,
                              unauthenticated: (_) => _submit,
                              error: (_) => _submit,
                            ),
                            child: authState.when(
                              loading: () => const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              initial: () => const Text('登录'),
                              authenticated: (_) => const Icon(Icons.check),
                              unauthenticated: (_) => const Text('登录'),
                              error: (_) => const Text('重试'),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 忘记密码
                        TextButton(
                          onPressed: () {
                            // TODO: 实现忘记密码功能
                          },
                          child: Text(
                            '忘记密码？',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 注册链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '还没有账号？',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: Text(
                      '立即注册',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
