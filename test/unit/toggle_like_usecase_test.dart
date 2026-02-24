import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_challenge/app/domain/entities/post.dart';
import 'package:social_challenge/app/domain/repositories/post_repository.dart';
import 'package:social_challenge/app/domain/usecases/toggle_like_usecase.dart';

@GenerateMocks([PostRepository])
import 'toggle_like_usecase_test.mocks.dart';

void main() {
  late ToggleLikeUseCase useCase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = ToggleLikeUseCase(mockRepository);
  });

  group('ToggleLikeUseCase', () {
    const tPostId = 1;
    const tPost = Post(
      id: 1,
      userId: 1,
      title: 'Test',
      body: 'Body',
      isLiked: true,
    );

    test('should toggle like state in repository', () async {
      // Arrange
      when(
        mockRepository.toggleLike(tPostId, true),
      ).thenAnswer((_) async => tPost);

      // Act
      final result = await useCase(tPostId, true);

      // Assert
      expect(result, tPost);
      expect(result.isLiked, true);
      verify(mockRepository.toggleLike(tPostId, true));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle unlike action', () async {
      // Arrange
      const unlikedPost = Post(
        id: 1,
        userId: 1,
        title: 'Test',
        body: 'Body',
        isLiked: false,
      );
      when(
        mockRepository.toggleLike(tPostId, false),
      ).thenAnswer((_) async => unlikedPost);

      // Act
      final result = await useCase(tPostId, false);

      // Assert
      expect(result.isLiked, false);
      verify(mockRepository.toggleLike(tPostId, false));
    });
  });
}
