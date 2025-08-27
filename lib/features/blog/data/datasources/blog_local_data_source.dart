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

/// Implémentation du cache local pour les blog posts
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
