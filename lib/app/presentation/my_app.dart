import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../config/providers/riverpod_providers.dart';
import '../config/router/router.dart';
import '../config/theme/app_theme.dart';
import 'bloc/home/home_cubit.dart';
import 'providers/animation_provider.dart';
import 'providers/search_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (_) => SearchProvider()),
          provider.ChangeNotifierProvider(create: (_) => AnimationProvider()),
        ],
        child: Consumer(
          builder: (context, WidgetRef ref, _) {
            return BlocProvider(
              create: (_) => HomeCubit(ref.read(getPostsUseCaseProvider)),
              child: MaterialApp.router(
                title: 'Social Challenge',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.system,
                routerConfig: appRouter,
              ),
            );
          },
        ),
      ),
    );
  }
}
