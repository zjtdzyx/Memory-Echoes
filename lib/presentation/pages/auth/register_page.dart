import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';
import 'package:memory_echoes/presentation/providers/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _displayName = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(authStateProvider.notifier)
          .signUpWithEmail(_email, _password, _displayName);
    }
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
      appBar: AppBar(title: const Text('注册')),
      body: Center(
        child: SingleChildScrollView(
          padding: const const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '创建您的记忆回响账户',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入用户名';
                        }
                        return null;
                      },
                      onSaved: (value) => _displayName = value!,
                    ),
                    const const SizedBox(height: 16),
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
                    const const SizedBox(height: 16),
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
                    const const SizedBox(height: 24),
                    const SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.maybeWhen(
                          loading: () => null,
                          authenticated: (_) => null,
                          orElse: () => _submit,
                        ),
                        child: authState.maybeWhen(
                          loading: () => const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          authenticated: (_) => const Icon(Icons.check),
                          orElse: () => const Text('注册'),
                        ),
                      ),
                    ),
                    const const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('已经有账户了？登录'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
