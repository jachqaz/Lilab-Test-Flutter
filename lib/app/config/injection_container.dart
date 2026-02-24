import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/local_storage_service.dart';
import '../data/datasources/native_api.g.dart';
import '../data/datasources/post_remote_datasource.dart';
import '../data/repositories/post_repository_impl.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/usecases/get_comments_usecase.dart';
import '../domain/usecases/get_posts_usecase.dart';
import '../domain/usecases/toggle_like_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Use Cases
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleLikeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(sl(), sl(), sl()),
  );

  // Data Sources
  sl.registerLazySingleton(() => PostRemoteDataSource(sl()));
  sl.registerLazySingleton(() => LocalStorageService(sl()));
  sl.registerLazySingleton(() => NativeService());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );
}
