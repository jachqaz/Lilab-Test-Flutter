import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:social_challenge/app/data/datasources/post_remote_datasource.dart';
import 'package:social_challenge/app/domain/entities/comment.dart';
import 'package:social_challenge/app/domain/entities/post.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late PostRemoteDataSource dataSource;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    dataSource = PostRemoteDataSource(dio);
  });

  group('PostRemoteDataSource - Black Box Testing', () {
    const baseUrl = 'https://jsonplaceholder.typicode.com';

    group('getPosts', () {
      test('should return list of posts when API call is successful', () async {
        // Arrange
        final mockResponse = [
          {'id': 1, 'userId': 1, 'title': 'Test Post', 'body': 'Test Body'},
          {'id': 2, 'userId': 1, 'title': 'Test Post 2', 'body': 'Test Body 2'},
        ];

        dioAdapter.onGet(
          '$baseUrl/posts',
          (server) => server.reply(200, mockResponse),
        );

        // Act
        final result = await dataSource.getPosts();

        // Assert
        expect(result, isA<List<Post>>());
        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].title, 'Test Post');
      });

      test('should throw exception when API call fails with 404', () async {
        // Arrange
        dioAdapter.onGet(
          '$baseUrl/posts',
          (server) => server.reply(404, {'message': 'Not Found'}),
        );

        // Act & Assert
        expect(() => dataSource.getPosts(), throwsA(isA<DioException>()));
      });

      test('should throw exception when API call fails with 500', () async {
        // Arrange
        dioAdapter.onGet(
          '$baseUrl/posts',
          (server) => server.reply(500, {'message': 'Internal Server Error'}),
        );

        // Act & Assert
        expect(() => dataSource.getPosts(), throwsA(isA<DioException>()));
      });

      test('should throw exception when network timeout occurs', () async {
        // Arrange
        dioAdapter.onGet(
          '$baseUrl/posts',
          (server) => server.throws(
            408,
            DioException.connectionTimeout(
              timeout: const Duration(seconds: 30),
              requestOptions: RequestOptions(path: '$baseUrl/posts'),
            ),
          ),
        );

        // Act & Assert
        expect(() => dataSource.getPosts(), throwsA(isA<DioException>()));
      });
    });

    group('getComments', () {
      const postId = 1;

      test(
        'should return list of comments when API call is successful',
        () async {
          // Arrange
          final mockResponse = [
            {
              'id': 1,
              'postId': 1,
              'name': 'Test Comment',
              'email': 'test@example.com',
              'body': 'Test Body',
            },
          ];

          dioAdapter.onGet(
            '$baseUrl/posts/$postId/comments',
            (server) => server.reply(200, mockResponse),
          );

          // Act
          final result = await dataSource.getComments(postId);

          // Assert
          expect(result, isA<List<Comment>>());
          expect(result.length, 1);
          expect(result[0].postId, postId);
          expect(result[0].email, 'test@example.com');
        },
      );

      test('should throw exception when comments API fails', () async {
        // Arrange
        dioAdapter.onGet(
          '$baseUrl/posts/$postId/comments',
          (server) => server.reply(404, {'message': 'Not Found'}),
        );

        // Act & Assert
        expect(
          () => dataSource.getComments(postId),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
