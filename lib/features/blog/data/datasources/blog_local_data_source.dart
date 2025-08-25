import '../models/blog_post_model.dart';

/// Interface pour la source de données locale (cache)
abstract class BlogLocalDataSource {
  /// Récupère tous les blog posts depuis le cache
  Future<List<BlogPostModel>> getAllBlogPosts();

  /// Récupère un blog post par son ID depuis le cache
  Future<BlogPostModel> getBlogPostById(int id);

  /// Cache une liste de blog posts
  Future<void> cacheBlogPosts(List<BlogPostModel> blogPosts);

  /// Cache un blog post
  Future<void> cacheBlogPost(BlogPostModel blogPost);

  /// Supprime un blog post du cache
  Future<void> removeBlogPost(int id);

  /// Nettoie tout le cache
  Future<void> clearCache();
}
