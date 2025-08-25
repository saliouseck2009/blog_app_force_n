import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_blog_posts.dart';
import '../../domain/usecases/get_blog_post_by_id.dart';
import 'blog_event.dart';
import 'blog_state.dart';

/// BLoC pour la gestion des blog posts
class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetAllBlogPosts getAllBlogPosts;
  final GetBlogPostById getBlogPostById;

  BlogBloc({required this.getAllBlogPosts, required this.getBlogPostById})
    : super(BlogInitial()) {
    on<GetAllBlogPostsEvent>(_onGetAllBlogPosts);
    on<GetBlogPostByIdEvent>(_onGetBlogPostById);
    on<RefreshBlogPostsEvent>(_onRefreshBlogPosts);
  }

  /// Gère l'événement pour récupérer tous les blog posts
  Future<void> _onGetAllBlogPosts(
    GetAllBlogPostsEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());

    final result = await getAllBlogPosts(const NoParams());

    if (result is DataSuccess) {
      emit(BlogLoaded(blogPosts: result.data!));
    } else if (result is DataFailed) {
      emit(BlogError(message: result.error!));
    }
  }

  /// Gère l'événement pour récupérer un blog post par ID
  Future<void> _onGetBlogPostById(
    GetBlogPostByIdEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());

    final result = await getBlogPostById(event.id);

    if (result is DataSuccess) {
      emit(BlogLoaded(blogPosts: [result.data!]));
    } else if (result is DataFailed) {
      emit(BlogError(message: result.error!));
    }
  }

  /// Gère l'événement pour rafraîchir les blog posts
  Future<void> _onRefreshBlogPosts(
    RefreshBlogPostsEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());

    final result = await getAllBlogPosts(const NoParams());

    if (result is DataSuccess) {
      emit(BlogLoaded(blogPosts: result.data!));
    } else if (result is DataFailed) {
      emit(BlogError(message: result.error!));
    }
  }
}
