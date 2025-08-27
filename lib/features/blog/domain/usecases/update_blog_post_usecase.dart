import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository.dart';

/// Use case pour mettre à jour un blog post existant
class UpdateBlogPostUseCase implements UseCase<BlogPost, BlogPost> {
  final BlogRepository repository;

  UpdateBlogPostUseCase(this.repository);

  @override
  Future<DataState<BlogPost>> call(BlogPost blogPost) async {
    return await repository.updateBlogPost(blogPost);
  }
}
