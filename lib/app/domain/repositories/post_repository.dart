import '../entities/comment.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();

  Future<List<Comment>> getComments(int postId);

  Future<Post> toggleLike(int postId, bool isLiked);
}
