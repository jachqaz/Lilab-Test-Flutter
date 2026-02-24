import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart' as provider;
import 'package:social_challenge/app/domain/entities/post.dart';
import 'package:social_challenge/app/domain/usecases/get_posts_usecase.dart';
import 'package:social_challenge/app/presentation/bloc/home/home_cubit.dart';
import 'package:social_challenge/app/presentation/pages/home_page.dart';
import 'package:social_challenge/app/presentation/providers/animation_provider.dart';
import 'package:social_challenge/app/presentation/providers/search_provider.dart';

@GenerateMocks([GetPostsUseCase])
import 'home_page_widget_test.mocks.dart';

void main() {
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (_) => SearchProvider()),
          provider.ChangeNotifierProvider(create: (_) => AnimationProvider()),
        ],
        child: BlocProvider(
          create: (_) => HomeCubit(mockGetPostsUseCase),
          child: const MaterialApp(home: HomePage()),
        ),
      ),
    );
  }

  group('HomePage Widget Tests', () {
    final tPosts = [
      const Post(
        id: 1,
        userId: 1,
        title: 'Flutter Post',
        body: 'Flutter is awesome',
        isLiked: false,
      ),
      const Post(
        id: 2,
        userId: 1,
        title: 'Dart Post',
        body: 'Dart is great',
        isLiked: false,
      ),
      const Post(
        id: 3,
        userId: 1,
        title: 'Mobile Dev',
        body: 'Mobile development',
        isLiked: false,
      ),
    ];

    testWidgets('should display search icon in AppBar', (tester) async {
      // Arrange
      when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should show search field when search icon is tapped', (
      tester,
    ) async {
      // Arrange
      when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar posts...'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should filter posts when searching', (tester) async {
      // Arrange
      when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Load posts
      final cubit = tester
          .widget<BlocProvider<HomeCubit>>(find.byType(BlocProvider<HomeCubit>))
          .create(tester.element(find.byType(BlocProvider<HomeCubit>)));
      await cubit.loadPosts();
      await tester.pumpAndSettle();

      // Open search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Assert
      expect(find.text('Flutter Post'), findsOneWidget);
      expect(find.text('Dart Post'), findsNothing);
    });

    testWidgets('should display all posts when search is cleared', (
      tester,
    ) async {
      // Arrange
      when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final cubit = tester
          .widget<BlocProvider<HomeCubit>>(find.byType(BlocProvider<HomeCubit>))
          .create(tester.element(find.byType(BlocProvider<HomeCubit>)));
      await cubit.loadPosts();
      await tester.pumpAndSettle();

      // Open search and search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Close search
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Flutter Post'), findsOneWidget);
      expect(find.text('Dart Post'), findsOneWidget);
      expect(find.text('Mobile Dev'), findsOneWidget);
    });

    testWidgets('should display skeleton loader while loading', (tester) async {
      // Arrange
      when(mockGetPostsUseCase()).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 2), () => tPosts),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert - Should show skeleton before data loads
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display error message when loading fails', (
      tester,
    ) async {
      // Arrange
      when(mockGetPostsUseCase()).thenThrow(Exception('Network error'));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final cubit = tester
          .widget<BlocProvider<HomeCubit>>(find.byType(BlocProvider<HomeCubit>))
          .create(tester.element(find.byType(BlocProvider<HomeCubit>)));
      await cubit.loadPosts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });
}
