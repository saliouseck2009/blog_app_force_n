import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository.dart';

/// Use case pour récupérer tous les blog posts
class GetAllBlogPosts implements UseCase<List<BlogPost>, NoParams> {
  final BlogRepository repository;

  GetAllBlogPosts(this.repository);

  @override
  Future<DataState<List<BlogPost>>> call(NoParams params) async {
    return await repository.getAllBlogPosts();
  }
}
