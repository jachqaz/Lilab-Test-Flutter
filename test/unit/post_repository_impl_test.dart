import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_challenge/app/data/datasources/local_storage_service.dart';
import 'package:social_challenge/app/data/datasources/native_api.g.dart';
import 'package:social_challenge/app/data/datasources/post_remote_datasource.dart';
import 'package:social_challenge/app/data/repositories/post_repository_impl.dart';
import 'package:social_challenge/app/domain/entities/comment.dart';
import 'package:social_challenge/app/domain/entities/post.dart';

@GenerateMocks([PostRemoteDataSource, LocalStorageService, NativeService])
import 'post_repository_impl_test.mocks.dart';

void main() {
  late PostRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockLocalStorageService mockLocalStorage;
  late MockNativeService mockNativeService;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockLocalStorage = MockLocalStorageService();
    mockNativeService = MockNativeService();
    repository = PostRepositoryImpl(
      mockRemoteDataSource,
      mockLocalStorage,
      mockNativeService,
    );
  });

  group('PostRepositoryImpl', () {
    final tPosts = [
      const Post(id: 1, userId: 1, title: 'Test', body: 'Body', isLiked: false),
      const Post(
        id: 2,
        userId: 1,
        title: 'Test 2',
        body: 'Body 2',
        isLiked: false,
      ),
    ];

    final tComments = [
      const Comment(
        id: 1,
        postId: 1,
        name: 'Comment',
        email: 'test@test.com',
        body: 'Body',
      ),
    ];

    test('should return posts with like state from local storage', () async {
      // Arrange
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);
      when(mockLocalStorage.getAllLikes()).thenAnswer((_) async => {1: true});

      // Act
      final result = await repository.getPosts();

      // Assert
      expect(result[0].isLiked, true);
      expect(result[1].isLiked, false);
      verify(mockRemoteDataSource.getPosts());
      verify(mockLocalStorage.getAllLikes());
    });

    test('should return comments from remote data source', () async {
      // Arrange
      when(
        mockRemoteDataSource.getComments(1),
      ).thenAnswer((_) async => tComments);

      // Act
      final result = await repository.getComments(1);

      // Assert
      expect(result, tComments);
      verify(mockRemoteDataSource.getComments(1));
    });

    test('should save like and send notification when toggling like', () async {
      // Arrange
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);
      when(mockLocalStorage.saveLike(1, true)).thenAnswer((_) async => {});

      // Act
      final result = await repository.toggleLike(1, true);

      // Assert
      expect(result.id, 1);
      expect(result.isLiked, true);
      verify(mockLocalStorage.saveLike(1, true));
      verify(mockNativeService.sendLocalNotification(any));
    });

    test('should not send notification when unliking', () async {
      // Arrange
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);
      when(mockLocalStorage.saveLike(1, false)).thenAnswer((_) async => {});

      // Act
      await repository.toggleLike(1, false);

      // Assert
      verify(mockLocalStorage.saveLike(1, false));
      verifyNever(mockNativeService.sendLocalNotification(any));
    });
  });
}
