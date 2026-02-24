import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/post.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetPostsUseCase _getPostsUseCase;
  List<Post> _allPosts = [];

  HomeCubit(this._getPostsUseCase) : super(const HomeState.initial());

  Future<void> loadPosts() async {
    emit(const HomeState.loading());
    try {
      _allPosts = await _getPostsUseCase();
      emit(HomeState.loaded(_allPosts));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      emit(HomeState.loaded(_allPosts));
      return;
    }

    final filtered = _allPosts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase()) ||
          post.body.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(HomeState.loaded(filtered, searchQuery: query));
  }

  void updatePostLike(int postId, bool isLiked) {
    final updatedPosts = _allPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(isLiked: isLiked);
      }
      return post;
    }).toList();

    _allPosts = updatedPosts;

    state.maybeWhen(
      loaded: (posts, searchQuery) {
        final updatedFilteredPosts = posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(isLiked: isLiked);
          }
          return post;
        }).toList();
        emit(HomeState.loaded(updatedFilteredPosts, searchQuery: searchQuery));
      },
      orElse: () {},
    );
  }
}
