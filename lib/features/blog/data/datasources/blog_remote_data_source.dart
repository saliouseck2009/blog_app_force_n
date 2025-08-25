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
}
