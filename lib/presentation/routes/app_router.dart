import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/splash/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/chat/ai_chat_page.dart';
import '../pages/discover/discover_page.dart';
import '../pages/story/story_list_page.dart';
import '../pages/story/story_detail_page.dart';
import '../pages/story/create_story_page.dart';
import '../pages/story/edit_story_page.dart';
import '../pages/biography/biography_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/search/search_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/error/error_page.dart';
import '../providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );

      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplashRoute = state.matchedLocation == '/splash';

      // 如果在启动页面，不重定向
      if (isSplashRoute) return null;

      // 如果未认证且不在认证页面，重定向到登录
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }

      // 如果已认证且在认证页面，重定向到首页
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    errorBuilder: (context, state) => ErrorPage(
      errorMessage: state.error?.toString(),
      errorCode: '404',
    ),
    routes: [
      // 启动页
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // 认证相关路由
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/register',
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
        path: '/discover',
        builder: (context, state) => const DiscoverPage(),
      ),
      GoRoute(
        path: '/stories',
        builder: (context, state) => const StoryListPage(),
      ),
      GoRoute(
        path: '/story/:id',
        builder: (context, state) {
          final storyId = state.pathParameters['id']!;
          return StoryDetailPage(storyId: storyId);
        },
      ),
      GoRoute(
        path: '/story/create',
        builder: (context, state) => const CreateStoryPage(),
      ),
      GoRoute(
        path: '/story/:id/edit',
        builder: (context, state) {
          final storyId = state.pathParameters['id']!;
          return EditStoryPage(storyId: storyId);
        },
      ),
      GoRoute(
        path: '/biography',
        builder: (context, state) => const BiographyPage(),
      ),
      GoRoute(
        path: '/biography/create',
        builder: (context, state) => const BiographyPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // 错误页面
      GoRoute(
        path: '/error',
        builder: (context, state) {
          final errorMessage = state.uri.queryParameters['message'];
          final errorCode = state.uri.queryParameters['code'];
          return ErrorPage(
            errorMessage: errorMessage,
            errorCode: errorCode,
          );
        },
      ),
    ],
  );
});
