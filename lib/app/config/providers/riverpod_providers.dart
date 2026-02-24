import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/toggle_like_usecase.dart';
import '../injection_container.dart';

// Use Cases Providers
final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) => sl());
final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) => sl());
final toggleLikeUseCaseProvider = Provider<ToggleLikeUseCase>((ref) => sl());

// Global Like State Provider
final likeStateProvider =
    StateNotifierProvider<LikeStateNotifier, Map<int, bool>>((ref) {
      return LikeStateNotifier();
    });

class LikeStateNotifier extends StateNotifier<Map<int, bool>> {
  LikeStateNotifier() : super({});

  void toggleLike(int postId, bool isLiked) {
    state = {...state, postId: isLiked};
  }

  bool isLiked(int postId) {
    return state[postId] ?? false;
  }
}
