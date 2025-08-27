import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core imports
import 'core/config/network/dio_config.dart';
import 'core/config/network/networking_service.dart';
import 'core/config/storage/secure_storage.dart';
import 'core/services/auth_service.dart';
import 'core/services/blog_service.dart';

// Blog imports
import 'features/blog/data/datasources/blog_remote_data_source.dart';
import 'features/blog/data/repositories/blog_repository_impl.dart';
import 'features/blog/domain/repositories/blog_repository.dart';
import 'features/blog/domain/usecases/get_all_blog_posts.dart';
import 'features/blog/domain/usecases/get_blog_post_by_id.dart';
import 'features/blog/domain/usecases/create_blog_post_usecase.dart';
import 'features/blog/domain/usecases/update_blog_post_usecase.dart';
import 'features/blog/domain/usecases/delete_blog_post_usecase.dart';
import 'features/blog/domain/usecases/search_blog_posts_usecase.dart';

// Auth imports
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';

/// Service Locator global
final sl = GetIt.instance;

/// Configuration de l'injection de dépendances
Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Core
  sl.registerLazySingleton(() => SecureStorage());
  sl.registerLazySingleton(
    () => NetworkingService(dio: dio, secureStorage: sl()),
  );
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton(() => BlogService(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(authService: sl(), secureStorage: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllBlogPosts(sl()));
  sl.registerLazySingleton(() => GetBlogPostById(sl()));
  sl.registerLazySingleton(() => CreateBlogPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBlogPostUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBlogPostUseCase(sl()));
  sl.registerLazySingleton(() => SearchBlogPostsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(blogService: sl()),
  );
}
