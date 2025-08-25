import 'package:get_it/get_it.dart';
import 'core/demo_data.dart';
import 'core/network/network_info.dart';
import 'features/blog/data/datasources/blog_local_data_source.dart';
import 'features/blog/data/datasources/blog_remote_data_source.dart';
import 'features/blog/data/models/blog_post_model.dart';
import 'features/blog/data/repositories/blog_repository_impl.dart';
import 'features/blog/domain/repositories/blog_repository.dart';
import 'features/blog/domain/usecases/get_all_blog_posts.dart';
import 'features/blog/domain/usecases/get_blog_post_by_id.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';

// Auth imports
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

/// Service Locator global
final sl = GetIt.instance;

/// Configuration de l'injection de dépendances
Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  //! Features - Blog
  // Bloc
  sl.registerFactory(
    () => BlogBloc(getAllBlogPosts: sl(), getBlogPostById: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllBlogPosts(sl()));
  sl.registerLazySingleton(() => GetBlogPostById(sl()));

  // Repository
  sl.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

// Implémentations temporaires pour la démo
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  @override
  Future<BlogPostModel> createBlogPost(BlogPostModel blogPost) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBlogPost(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<BlogPostModel>> getAllBlogPosts() async {
    // Simulation d'un délai réseau (supprimé pour les tests)
    // await Future.delayed(const Duration(seconds: 1));
    return DemoData.getBlogPosts()
        .map((json) => BlogPostModel.fromJson(json))
        .toList();
  }

  @override
  Future<BlogPostModel> getBlogPostById(int id) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    final posts = DemoData.getBlogPosts();
    final post = posts.firstWhere((p) => p['id'] == id);
    return BlogPostModel.fromJson(post);
  }

  @override
  Future<BlogPostModel> updateBlogPost(BlogPostModel blogPost) async {
    throw UnimplementedError();
  }
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  static List<BlogPostModel> _cache = [];

  @override
  Future<void> cacheBlogPost(BlogPostModel blogPost) async {
    _cache.removeWhere((post) => post.id == blogPost.id);
    _cache.add(blogPost);
  }

  @override
  Future<void> cacheBlogPosts(List<BlogPostModel> blogPosts) async {
    _cache = blogPosts;
  }

  @override
  Future<void> clearCache() async {
    _cache.clear();
  }

  @override
  Future<List<BlogPostModel>> getAllBlogPosts() async {
    if (_cache.isEmpty) {
      throw Exception('Pas de données en cache');
    }
    return _cache;
  }

  @override
  Future<BlogPostModel> getBlogPostById(int id) async {
    if (_cache.isEmpty) {
      throw Exception('Pas de données en cache');
    }
    return _cache.firstWhere((post) => post.id == id);
  }

  @override
  Future<void> removeBlogPost(int id) async {
    _cache.removeWhere((post) => post.id == id);
  }
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    return true; // Toujours connecté pour la démo
  }
}
