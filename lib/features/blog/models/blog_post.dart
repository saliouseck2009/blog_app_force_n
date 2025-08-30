import 'package:equatable/equatable.dart';

/// Entité Blog Post pour la couche Domain
class BlogPost extends Equatable {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? imageUrl;

  const BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    author,
    createdAt,
    updatedAt,
    tags,
    imageUrl,
  ];
}
