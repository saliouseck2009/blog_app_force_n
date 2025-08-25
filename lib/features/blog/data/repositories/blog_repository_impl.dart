import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_local_data_source.dart';
import '../datasources/blog_remote_data_source.dart';

/// Implémentation concrète du repository des blog posts
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BlogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DataState<List<BlogPost>>> getAllBlogPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBlogPosts = await remoteDataSource.getAllBlogPosts();
        await localDataSource.cacheBlogPosts(remoteBlogPosts);
        return DataSuccess(remoteBlogPosts);
      } catch (e) {
        return DataFailed('Erreur serveur: ${e.toString()}');
      }
    } else {
      try {
        final localBlogPosts = await localDataSource.getAllBlogPosts();
        return DataSuccess(localBlogPosts);
      } catch (e) {
        return DataFailed('Erreur cache: ${e.toString()}');
      }
    }
  }

  @override
  Future<DataState<BlogPost>> getBlogPostById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBlogPost = await remoteDataSource.getBlogPostById(id);
        await localDataSource.cacheBlogPost(remoteBlogPost);
        return DataSuccess(remoteBlogPost);
      } catch (e) {
        return DataFailed('Erreur serveur: ${e.toString()}');
      }
    } else {
      try {
        final localBlogPost = await localDataSource.getBlogPostById(id);
        return DataSuccess(localBlogPost);
      } catch (e) {
        return DataFailed('Erreur cache: ${e.toString()}');
      }
    }
  }

  @override
  Future<DataState<BlogPost>> createBlogPost(BlogPost blogPost) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBlogPost = await remoteDataSource.createBlogPost(
          _toModel(blogPost),
        );
        await localDataSource.cacheBlogPost(remoteBlogPost);
        return DataSuccess(remoteBlogPost);
      } catch (e) {
        return DataFailed('Erreur serveur: ${e.toString()}');
      }
    } else {
      return DataFailed('Pas de connexion internet');
    }
  }

  @override
  Future<DataState<BlogPost>> updateBlogPost(BlogPost blogPost) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBlogPost = await remoteDataSource.updateBlogPost(
          _toModel(blogPost),
        );
        await localDataSource.cacheBlogPost(remoteBlogPost);
        return DataSuccess(remoteBlogPost);
      } catch (e) {
        return DataFailed('Erreur serveur: ${e.toString()}');
      }
    } else {
      return DataFailed('Pas de connexion internet');
    }
  }

  @override
  Future<DataState<void>> deleteBlogPost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteBlogPost(id);
        await localDataSource.removeBlogPost(id);
        return DataSuccess(null);
      } catch (e) {
        return DataFailed('Erreur serveur: ${e.toString()}');
      }
    } else {
      return DataFailed('Pas de connexion internet');
    }
  }

  /// Convertit une entité BlogPost en BlogPostModel
  _toModel(BlogPost blogPost) {
    return blogPost;
  }
}
