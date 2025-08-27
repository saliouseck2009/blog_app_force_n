import '../config/network/networking_service.dart';
import '../config/network/dio_config.dart';

class BlogService {
  final NetworkingService _networkingService;

  BlogService(this._networkingService);

  /// Récupération de tous les blog posts
  Future<List<dynamic>> getAllBlogPosts() async {
    final response = await _networkingService.get(
      ApiEndpoints.blogs,
      requiresToken: false,
    );

    return response.data as List<dynamic>;
  }

  /// Récupération d'un blog post par son ID
  Future<Map<String, dynamic>> getBlogPostById(int id) async {
    final response = await _networkingService.get(
      ApiEndpoints.blogById(id),
      requiresToken: false,
    );

    return response.data;
  }

  /// Création d'un nouveau blog post
  Future<Map<String, dynamic>> createBlogPost({
    required String title,
    required String content,
    required String author,
    required List<String> tags,
  }) async {
    final response = await _networkingService.post(
      ApiEndpoints.blogs,
      requiresToken: true,
      data: {
        'title': title,
        'content': content,
        'author': author,
        'tags': tags,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

    return response.data;
  }

  /// Mise à jour d'un blog post existant
  Future<Map<String, dynamic>> updateBlogPost({
    required int id,
    required String title,
    required String content,
    required String author,
    required List<String> tags,
  }) async {
    final response = await _networkingService.put(
      ApiEndpoints.blogById(id),
      requiresToken: true,
      data: {
        'title': title,
        'content': content,
        'author': author,
        'tags': tags,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );

    return response.data;
  }

  /// Suppression d'un blog post
  Future<void> deleteBlogPost(int id) async {
    await _networkingService.delete(
      ApiEndpoints.blogById(id),
      requiresToken: true,
    );
  }

  /// Recherche de blog posts par titre ou contenu
  Future<List<dynamic>> searchBlogPosts(String query) async {
    final response = await _networkingService.get(
      ApiEndpoints.blogs,
      requiresToken: false,
      queryParameters: {'search': query},
    );

    return response.data as List<dynamic>;
  }

  /// Récupération des blog posts par auteur
  Future<List<dynamic>> getBlogPostsByAuthor(String author) async {
    final response = await _networkingService.get(
      ApiEndpoints.blogs,
      requiresToken: false,
      queryParameters: {'author': author},
    );

    return response.data as List<dynamic>;
  }

  /// Récupération des blog posts par tag
  Future<List<dynamic>> getBlogPostsByTag(String tag) async {
    final response = await _networkingService.get(
      ApiEndpoints.blogs,
      requiresToken: false,
      queryParameters: {'tag': tag},
    );

    return response.data as List<dynamic>;
  }
}
