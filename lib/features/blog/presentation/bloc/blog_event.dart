import 'package:equatable/equatable.dart';

/// Événements possibles pour les blog posts
abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour récupérer tous les blog posts
class GetAllBlogPostsEvent extends BlogEvent {}

/// Événement pour récupérer un blog post par ID
class GetBlogPostByIdEvent extends BlogEvent {
  final int id;

  const GetBlogPostByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

/// Événement pour rafraîchir les blog posts
class RefreshBlogPostsEvent extends BlogEvent {}
