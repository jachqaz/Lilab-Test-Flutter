import 'package:dio/dio.dart';

import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';

class PostRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  PostRemoteDataSource(this._dio);

  Future<List<Post>> getPosts() async {
    final response = await _dio.get('$_baseUrl/posts');
    return (response.data as List).map((json) => Post.fromJson(json)).toList();
  }

  Future<List<Comment>> getComments(int postId) async {
    final response = await _dio.get('$_baseUrl/posts/$postId/comments');
    return (response.data as List)
        .map((json) => Comment.fromJson(json))
        .toList();
  }
}
