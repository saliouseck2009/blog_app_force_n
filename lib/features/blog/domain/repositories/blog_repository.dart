import '../entities/blog_post.dart';

/// Interface du repository pour les blog posts
abstract class BlogRepository {
  /// Récupère tous les blog posts
  Future<List<BlogPost>> getAllBlogPosts();

  /// Récupère un blog post par son ID
  Future<BlogPost> getBlogPostById(int id);

  /// Crée un nouveau blog post
  Future<BlogPost> createBlogPost(BlogPost blogPost);

  /// Met à jour un blog post existant
  Future<BlogPost> updateBlogPost(BlogPost blogPost);

  /// Supprime un blog post
  Future<void> deleteBlogPost(int id);
}
