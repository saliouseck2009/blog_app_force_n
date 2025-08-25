import 'package:equatable/equatable.dart';

/// États possibles pour les blog posts
abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

/// État initial
class BlogInitial extends BlogState {}

/// État de chargement
class BlogLoading extends BlogState {}

/// État de succès avec les données
class BlogLoaded extends BlogState {
  final List<dynamic> blogPosts; // Utilise dynamic temporairement

  const BlogLoaded({required this.blogPosts});

  @override
  List<Object> get props => [blogPosts];
}

/// État d'erreur
class BlogError extends BlogState {
  final String message;

  const BlogError({required this.message});

  @override
  List<Object> get props => [message];
}
