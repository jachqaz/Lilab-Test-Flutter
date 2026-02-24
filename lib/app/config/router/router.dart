import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/modules/home/views/homeView.dart';
import '../../presentation/myApp.dart';
import 'paths.dart';
import 'routes.dart';

mixin RouterMixin on State<MyApp> {
  final _router = GoRouter(
    initialLocation: Paths.root,
    errorBuilder: (_, state) => HomeView(),
    routes: [
      GoRoute(
        name: Routes.home,
        path: Paths.home,
        builder: (_, __) => HomeView(),
      ),
    ],
  );

  GoRouter get router => _router;
}
