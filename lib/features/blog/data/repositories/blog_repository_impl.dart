import '../../../../core/resources/data_state.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_remote_data_source.dart';
import '../models/blog_post_model.dart';

/// Implémentation concrète du repository des blog posts
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;

  BlogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<BlogPost>>> getAllBlogPosts() async {
    try {
      final remoteBlogPosts = await remoteDataSource.getAllBlogPosts();
      return DataSuccess(remoteBlogPosts);
    } catch (e) {
      return DataFailed('Erreur serveur: ${e.toString()}');
    }
  }

  @override
  Future<DataState<BlogPost>> getBlogPostById(int id) async {
    try {
      final remoteBlogPost = await remoteDataSource.getBlogPostById(id);
      return DataSuccess(remoteBlogPost);
    } catch (e) {
      return DataFailed('Erreur serveur: ${e.toString()}');
    }
  }

  @override
  Future<DataState<BlogPost>> createBlogPost(BlogPost blogPost) async {
    try {
      final remoteBlogPost = await remoteDataSource.createBlogPost(
        _toModel(blogPost),
      );
      return DataSuccess(remoteBlogPost);
    } catch (e) {
      return DataFailed('Erreur serveur: ${e.toString()}');
    }
  }

  @override
  Future<DataState<BlogPost>> updateBlogPost(BlogPost blogPost) async {
    try {
      final remoteBlogPost = await remoteDataSource.updateBlogPost(
        _toModel(blogPost),
      );
      return DataSuccess(remoteBlogPost);
    } catch (e) {
      return DataFailed('Erreur serveur: ${e.toString()}');
    }
  }

  @override
  Future<DataState<void>> deleteBlogPost(int id) async {
    try {
      await remoteDataSource.deleteBlogPost(id);
      return DataSuccess(null);
    } catch (e) {
      return DataFailed('Erreur serveur: ${e.toString()}');
    }
  }

  /// Convertit une entité BlogPost en modèle BlogPostModel
  BlogPostModel _toModel(BlogPost blogPost) {
    return BlogPostModel(
      id: blogPost.id,
      title: blogPost.title,
      content: blogPost.content,
      author: blogPost.author,
      createdAt: blogPost.createdAt,
      updatedAt: blogPost.updatedAt,
      tags: blogPost.tags,
      imageUrl: blogPost.imageUrl,
    );
  }
}
