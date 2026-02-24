import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_challenge/app/domain/entities/post.dart';
import 'package:social_challenge/app/domain/repositories/post_repository.dart';
import 'package:social_challenge/app/domain/usecases/get_posts_usecase.dart';

@GenerateMocks([PostRepository])
import 'get_posts_usecase_test.mocks.dart';

void main() {
  late GetPostsUseCase useCase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = GetPostsUseCase(mockRepository);
  });

  group('GetPostsUseCase', () {
    final tPosts = [
      const Post(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test Body',
        isLiked: false,
      ),
      const Post(
        id: 2,
        userId: 1,
        title: 'Test Post 2',
        body: 'Test Body 2',
        isLiked: true,
      ),
    ];

    test('should get posts from repository', () async {
      // Arrange
      when(mockRepository.getPosts()).thenAnswer((_) async => tPosts);

      // Act
      final result = await useCase();

      // Assert
      expect(result, tPosts);
      verify(mockRepository.getPosts());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(mockRepository.getPosts()).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
      verify(mockRepository.getPosts());
    });
  });
}
