import '../../../../core/resources/data_state.dart';
import '../entities/blog_post.dart';

/// Interface du repository pour les blog posts
abstract class BlogRepository {
  /// Récupère tous les blog posts
  Future<DataState<List<BlogPost>>> getAllBlogPosts();

  /// Récupère un blog post par son ID
  Future<DataState<BlogPost>> getBlogPostById(int id);

  /// Crée un nouveau blog post
  Future<DataState<BlogPost>> createBlogPost(BlogPost blogPost);

  /// Met à jour un blog post existant
  Future<DataState<BlogPost>> updateBlogPost(BlogPost blogPost);

  /// Supprime un blog post
  Future<DataState<void>> deleteBlogPost(int id);
}
