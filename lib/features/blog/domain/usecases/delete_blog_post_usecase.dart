import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/blog_repository.dart';

/// Paramètres pour supprimer un blog post
class DeleteBlogPostParams {
  final int id;

  const DeleteBlogPostParams({required this.id});
}

/// Use case pour supprimer un blog post
class DeleteBlogPostUseCase implements UseCase<void, DeleteBlogPostParams> {
  final BlogRepository repository;

  DeleteBlogPostUseCase(this.repository);

  @override
  Future<DataState<void>> call(DeleteBlogPostParams params) async {
    return await repository.deleteBlogPost(params.id);
  }
}
