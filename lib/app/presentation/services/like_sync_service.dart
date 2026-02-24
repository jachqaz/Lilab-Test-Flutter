import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/providers/riverpod_providers.dart';
import '../../domain/usecases/toggle_like_usecase.dart';
import '../bloc/home/home_cubit.dart';

class LikeSyncService {
  final WidgetRef ref;
  final HomeCubit homeCubit;

  LikeSyncService(this.ref, this.homeCubit);

  Future<void> toggleLike(int postId, bool currentLikeState) async {
    final newLikeState = !currentLikeState;

    // Update global state (Riverpod)
    ref.read(likeStateProvider.notifier).toggleLike(postId, newLikeState);

    // Update HomeCubit state
    homeCubit.updatePostLike(postId, newLikeState);

    // Persist to backend/local storage
    final toggleLikeUseCase = ref.read(toggleLikeUseCaseProvider);
    await toggleLikeUseCase(postId, newLikeState);
  }
}
