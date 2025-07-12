import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/splash/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/chat/ai_chat_page.dart';
import '../pages/story/story_list_page.dart';
import '../pages/story/create_story_page.dart';
import '../pages/story/story_detail_page.dart';
import '../pages/story/edit_story_page.dart';
import '../pages/social/social_square_page.dart';
import '../pages/biography/biography_page.dart';
import '../pages/search/search_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/profile/profile_page.dart';
import '../providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated =
          authState.maybeWhen(authenticated: (_) => true, orElse: () => false);
      final isAuthRoute = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';

      // 如果在启动页面，不重定向
      if (isSplash) return null;

      // 如果未认证且不在认证页面，重定向到登录页
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // 如果已认证且在认证页面，重定向到首页
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // 启动页
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // 认证路由
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // 主要功能路由
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const AiChatPage(),
      ),
      GoRoute(
        path: '/stories',
        builder: (context, state) => const StoryListPage(),
      ),
      GoRoute(
        path: '/story/create',
        builder: (context, state) => const CreateStoryPage(),
      ),
      GoRoute(
        path: '/story/:id',
        builder: (context, state) {
          final storyId = state.pathParameters['id']!;
          return StoryDetailPage(storyId: storyId);
        },
      ),
      GoRoute(
        path: '/story/:id/edit',
        builder: (context, state) {
          final storyId = state.pathParameters['id']!;
          return EditStoryPage(storyId: storyId);
        },
      ),
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialSquarePage(),
      ),
      GoRoute(
        path: '/biography',
        builder: (context, state) => const BiographyPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // 其他页面路由
      GoRoute(
        path: '/timeline',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('连续功能即将推出'),
          ),
        ),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('收藏夹功能即将推出'),
          ),
        ),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('帮助页面即将推出'),
          ),
        ),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('关于页面即将推出'),
          ),
        ),
      ),
    ],
  );
});
