import '../entities/post.dart';
import '../repositories/post_repository.dart';

class ToggleLikeUseCase {
  final PostRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<Post> call(int postId, bool isLiked) async {
    return await repository.toggleLike(postId, isLiked);
  }
}
