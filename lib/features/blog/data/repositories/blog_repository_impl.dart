import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';

/// Implémentation concrète du repository des blog posts
class BlogRepositoryImpl implements BlogRepository {
  BlogRepositoryImpl();

  @override
  Future<BlogPost> createBlogPost(BlogPost blogPost) {
    // TODO: implement createBlogPost
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBlogPost(int id) {
    // TODO: implement deleteBlogPost
    throw UnimplementedError();
  }

  @override
  Future<List<BlogPost>> getAllBlogPosts() {
    // TODO: implement getAllBlogPosts
    throw UnimplementedError();
  }

  @override
  Future<BlogPost> getBlogPostById(int id) {
    // TODO: implement getBlogPostById
    throw UnimplementedError();
  }

  @override
  Future<BlogPost> updateBlogPost(BlogPost blogPost) {
    // TODO: implement updateBlogPost
    throw UnimplementedError();
  }
}
