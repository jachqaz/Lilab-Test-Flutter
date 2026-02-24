import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/comment.dart';

part 'post_detail_state.freezed.dart';

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = _Initial;

  const factory PostDetailState.loading() = _Loading;

  const factory PostDetailState.loaded(List<Comment> comments) = _Loaded;

  const factory PostDetailState.error(String message) = _Error;
}
