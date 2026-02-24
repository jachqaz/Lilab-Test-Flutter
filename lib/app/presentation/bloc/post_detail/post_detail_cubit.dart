import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_comments_usecase.dart';
import 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final GetCommentsUseCase _getCommentsUseCase;

  PostDetailCubit(this._getCommentsUseCase)
    : super(const PostDetailState.initial());

  Future<void> loadComments(int postId) async {
    emit(const PostDetailState.loading());
    try {
      final comments = await _getCommentsUseCase(postId);
      emit(PostDetailState.loaded(comments));
    } catch (e) {
      emit(PostDetailState.error(e.toString()));
    }
  }
}
