import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_challenge/app/data/datasources/local_storage_service.dart';
import 'package:social_challenge/app/data/datasources/native_api.g.dart';
import 'package:social_challenge/app/data/datasources/post_remote_datasource.dart';
import 'package:social_challenge/app/data/repositories/post_repository_impl.dart';
import 'package:social_challenge/app/domain/entities/post.dart';

@GenerateMocks([PostRemoteDataSource, NativeService])
import 'like_persistence_regression_test.mocks.dart';

void main() {
  late PostRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockNativeService mockNativeService;
  late LocalStorageService localStorage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    mockRemoteDataSource = MockPostRemoteDataSource();
    mockNativeService = MockNativeService();
    localStorage = LocalStorageService(prefs);

    repository = PostRepositoryImpl(
      mockRemoteDataSource,
      localStorage,
      mockNativeService,
    );
  });

  group('Like Persistence - Regression Tests', () {
    final tPosts = [
      const Post(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Body',
        isLiked: false,
      ),
      const Post(
        id: 2,
        userId: 1,
        title: 'Test Post 2',
        body: 'Body 2',
        isLiked: false,
      ),
    ];

    test('should persist like state after toggling', () async {
      // Arrange
      const postId = 1;
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);

      // Act - Toggle like
      await repository.toggleLike(postId, true);

      // Assert - Verify like is persisted
      final isLiked = localStorage.getLike(postId);
      expect(isLiked, true);
    });

    test('should maintain like state when fetching posts again', () async {
      // Arrange
      const postId = 1;
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);

      // Act - Toggle like and fetch posts again
      await repository.toggleLike(postId, true);
      final posts = await repository.getPosts();

      // Assert - Like state should be maintained
      final likedPost = posts.firstWhere((p) => p.id == postId);
      expect(likedPost.isLiked, true);
    });

    test('should not lose like state when navigating back', () async {
      // Arrange
      const postId = 1;
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);

      // Act - Simulate navigation flow
      // 1. User likes post in detail page
      await repository.toggleLike(postId, true);

      // 2. User navigates back to home
      final postsAfterBack = await repository.getPosts();

      // 3. User navigates to detail again
      final postsSecondTime = await repository.getPosts();

      // Assert - Like state persists across navigation
      final likedPostFirstTime = postsAfterBack.firstWhere(
        (p) => p.id == postId,
      );
      final likedPostSecondTime = postsSecondTime.firstWhere(
        (p) => p.id == postId,
      );

      expect(likedPostFirstTime.isLiked, true);
      expect(likedPostSecondTime.isLiked, true);
    });

    test('should handle multiple likes and unlikes correctly', () async {
      // Arrange
      const postId = 1;
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);

      // Act - Toggle multiple times
      await repository.toggleLike(postId, true);
      expect(localStorage.getLike(postId), true);

      await repository.toggleLike(postId, false);
      expect(localStorage.getLike(postId), false);

      await repository.toggleLike(postId, true);
      expect(localStorage.getLike(postId), true);

      // Assert - Final state should be liked
      final posts = await repository.getPosts();
      final post = posts.firstWhere((p) => p.id == postId);
      expect(post.isLiked, true);
    });

    test('should maintain likes for multiple posts independently', () async {
      // Arrange
      when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);

      // Act - Like different posts
      await repository.toggleLike(1, true);
      await repository.toggleLike(2, true);
      await repository.toggleLike(1, false);

      // Assert - Each post maintains independent state
      final posts = await repository.getPosts();
      final post1 = posts.firstWhere((p) => p.id == 1);
      final post2 = posts.firstWhere((p) => p.id == 2);

      expect(post1.isLiked, false);
      expect(post2.isLiked, true);
    });

    test(
      'should trigger notification only when liking, not unliking',
      () async {
        // Arrange
        const postId = 1;
        when(mockRemoteDataSource.getPosts()).thenAnswer((_) async => tPosts);

        // Act - Like
        await repository.toggleLike(postId, true);

        // Assert - Notification sent
        verify(mockNativeService.sendLocalNotification(any)).called(1);

        // Act - Unlike
        await repository.toggleLike(postId, false);

        // Assert - No additional notification
        verifyNever(mockNativeService.sendLocalNotification(any));
      },
    );
  });
}
