import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/post_detail_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/post/:id',
      name: 'postDetail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PostDetailPage(postId: id);
      },
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
);
