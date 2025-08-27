import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository.dart';

/// Use case pour créer un nouveau blog post
class CreateBlogPostUseCase implements UseCase<BlogPost, BlogPost> {
  final BlogRepository repository;

  CreateBlogPostUseCase(this.repository);

  @override
  Future<DataState<BlogPost>> call(BlogPost blogPost) async {
    return await repository.createBlogPost(blogPost);
  }
}
