// Helper pour les tests - version mock des data sources
import 'package:blog_app/features/blog/data/models/blog_post_model.dart';
import 'package:blog_app/core/demo_data.dart';

class MockBlogRemoteDataSource {
  Future<List<BlogPostModel>> getAllBlogPosts() async {
    // Pas de délai pour les tests
    return DemoData.getBlogPosts()
        .map((json) => BlogPostModel.fromJson(json))
        .toList();
  }

  Future<BlogPostModel> getBlogPostById(int id) async {
    final posts = DemoData.getBlogPosts();
    final post = posts.firstWhere((p) => p['id'] == id);
    return BlogPostModel.fromJson(post);
  }
}

class MockBlogLocalDataSource {
  static List<BlogPostModel> _cache = [];

  Future<void> cacheBlogPosts(List<BlogPostModel> blogPosts) async {
    _cache = blogPosts;
  }

  Future<List<BlogPostModel>> getAllBlogPosts() async {
    if (_cache.isEmpty) {
      throw Exception('Pas de données en cache');
    }
    return _cache;
  }
}

class MockNetworkInfo {
  Future<bool> get isConnected async => true;
}
