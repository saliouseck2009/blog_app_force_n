import '../../../../core/services/blog_service.dart';
import '../models/blog_post_model.dart';

/// Interface pour la source de données distante
abstract class BlogRemoteDataSource {
  /// Récupère tous les blog posts depuis l'API
  Future<List<BlogPostModel>> getAllBlogPosts();

  /// Récupère un blog post par son ID depuis l'API
  Future<BlogPostModel> getBlogPostById(int id);

  /// Crée un nouveau blog post via l'API
  Future<BlogPostModel> createBlogPost(BlogPostModel blogPost);

  /// Met à jour un blog post via l'API
  Future<BlogPostModel> updateBlogPost(BlogPostModel blogPost);

  /// Supprime un blog post via l'API
  Future<void> deleteBlogPost(int id);

  /// Recherche des blog posts par mot-clé via l'API
  Future<List<BlogPostModel>> searchBlogPosts(String query);
}

/// Implémentation concrète du data source distant pour les blogs
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final BlogService _blogService;

  BlogRemoteDataSourceImpl({required BlogService blogService})
    : _blogService = blogService;

  @override
  Future<List<BlogPostModel>> getAllBlogPosts() async {
    final response = await _blogService.getAllBlogPosts();
    return response
        .map((json) => BlogPostModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BlogPostModel> getBlogPostById(int id) async {
    final response = await _blogService.getBlogPostById(id);
    return BlogPostModel.fromJson(response);
  }

  @override
  Future<BlogPostModel> createBlogPost(BlogPostModel blogPost) async {
    final response = await _blogService.createBlogPost(
      title: blogPost.title,
      content: blogPost.content,
      author: blogPost.author,
      tags: blogPost.tags,
    );
    return BlogPostModel.fromJson(response);
  }

  @override
  Future<BlogPostModel> updateBlogPost(BlogPostModel blogPost) async {
    final response = await _blogService.updateBlogPost(
      id: blogPost.id,
      title: blogPost.title,
      content: blogPost.content,
      author: blogPost.author,
      tags: blogPost.tags,
    );
    return BlogPostModel.fromJson(response);
  }

  @override
  Future<void> deleteBlogPost(int id) async {
    await _blogService.deleteBlogPost(id);
  }

  @override
  Future<List<BlogPostModel>> searchBlogPosts(String query) async {
    final response = await _blogService.searchBlogPosts(query);
    return response.map((json) => BlogPostModel.fromJson(json)).toList();
  }
}
