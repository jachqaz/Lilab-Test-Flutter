import '../entities/comment.dart';
import '../repositories/post_repository.dart';

class GetCommentsUseCase {
  final PostRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<Comment>> call(int postId) async {
    return await repository.getComments(postId);
  }
}
