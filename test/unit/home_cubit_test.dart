import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_challenge/app/domain/entities/post.dart';
import 'package:social_challenge/app/domain/usecases/get_posts_usecase.dart';
import 'package:social_challenge/app/presentation/bloc/home/home_cubit.dart';
import 'package:social_challenge/app/presentation/bloc/home/home_state.dart';

@GenerateMocks([GetPostsUseCase])
import 'home_cubit_test.mocks.dart';

void main() {
  late HomeCubit cubit;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    cubit = HomeCubit(mockGetPostsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('HomeCubit - White Box Testing', () {
    final tPosts = [
      const Post(
        id: 1,
        userId: 1,
        title: 'Flutter',
        body: 'Flutter is awesome',
        isLiked: false,
      ),
      const Post(
        id: 2,
        userId: 1,
        title: 'Dart',
        body: 'Dart is great',
        isLiked: false,
      ),
    ];

    test('initial state should be HomeState.initial()', () {
      expect(cubit.state, const HomeState.initial());
    });

    blocTest<HomeCubit, HomeState>(
      'emits [loading, loaded] when loadPosts is successful',
      build: () {
        when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);
        return cubit;
      },
      act: (cubit) => cubit.loadPosts(),
      expect: () => [const HomeState.loading(), HomeState.loaded(tPosts)],
      verify: (_) {
        verify(mockGetPostsUseCase()).called(1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits [loading, error] when loadPosts fails',
      build: () {
        when(mockGetPostsUseCase()).thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => cubit.loadPosts(),
      expect: () => [
        const HomeState.loading(),
        const HomeState.error('Exception: Network error'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'filters posts correctly when searchPosts is called',
      build: () {
        when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadPosts();
        cubit.searchPosts('Flutter');
      },
      expect: () => [
        const HomeState.loading(),
        HomeState.loaded(tPosts),
        HomeState.loaded([tPosts[0]], searchQuery: 'Flutter'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'updates post like state correctly',
      build: () {
        when(mockGetPostsUseCase()).thenAnswer((_) async => tPosts);
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadPosts();
        cubit.updatePostLike(1, true);
      },
      expect: () => [
        const HomeState.loading(),
        HomeState.loaded(tPosts),
        HomeState.loaded([
          const Post(
            id: 1,
            userId: 1,
            title: 'Flutter',
            body: 'Flutter is awesome',
            isLiked: true,
          ),
          tPosts[1],
        ]),
      ],
    );
  });
}
