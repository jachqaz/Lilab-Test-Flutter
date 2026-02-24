import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/local_storage_service.dart';
import '../datasources/native_api.g.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;
  final LocalStorageService _localStorage;
  final NativeService _nativeService;

  PostRepositoryImpl(
    this._remoteDataSource,
    this._localStorage,
    this._nativeService,
  );

  @override
  Future<List<Post>> getPosts() async {
    final posts = await _remoteDataSource.getPosts();
    final likes = await _localStorage.getAllLikes();

    return posts.map((post) {
      final isLiked = likes[post.id] ?? false;
      return post.copyWith(isLiked: isLiked);
    }).toList();
  }

  @override
  Future<List<Comment>> getComments(int postId) async {
    return await _remoteDataSource.getComments(postId);
  }

  @override
  Future<Post> toggleLike(int postId, bool isLiked) async {
    await _localStorage.saveLike(postId, isLiked);

    final posts = await _remoteDataSource.getPosts();
    final post = posts.firstWhere((p) => p.id == postId);

    if (isLiked) {
      _nativeService.sendLocalNotification(
        NotificationPayload(
          id: postId.toString(),
          titulo: 'Te ha gustado',
          mensaje: 'Te ha gustado: ${post.title}',
        ),
      );
    }

    return post.copyWith(isLiked: isLiked);
  }
}
