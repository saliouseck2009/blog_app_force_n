import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository.dart';

/// Paramètres pour rechercher des blog posts
class SearchBlogPostsParams {
  final String query;

  const SearchBlogPostsParams({required this.query});
}

/// Use case pour rechercher des blog posts par mot-clé
class SearchBlogPostsUseCase
    implements UseCase<List<BlogPost>, SearchBlogPostsParams> {
  final BlogRepository repository;

  SearchBlogPostsUseCase(this.repository);

  @override
  Future<DataState<List<BlogPost>>> call(SearchBlogPostsParams params) async {
    return await repository.searchBlogPosts(params.query);
  }
}
