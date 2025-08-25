import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository.dart';

/// Use case pour récupérer un blog post par son ID
class GetBlogPostById implements UseCase<BlogPost, int> {
  final BlogRepository repository;

  GetBlogPostById(this.repository);

  @override
  Future<DataState<BlogPost>> call(int id) async {
    return await repository.getBlogPostById(id);
  }
}
