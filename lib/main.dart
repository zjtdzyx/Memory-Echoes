import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_theme.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 加载环境变量
  await dotenv.load(fileName: ".env");
  
  // 初始化 Firebase
  await Firebase.initializeApp();
  
  runApp(
    ProviderScope(
      child: const MemoryEchoesApp(),
    ),
  );
}

class MemoryEchoesApp extends ConsumerWidget {
  const MemoryEchoesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title:
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: '记忆回响',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
