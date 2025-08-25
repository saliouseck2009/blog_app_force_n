import '../../domain/entities/blog_post.dart';

/// Modèle de données pour BlogPost avec sérialisation JSON
class BlogPostModel extends BlogPost {
  const BlogPostModel({
    required super.id,
    required super.title,
    required super.content,
    required super.author,
    required super.createdAt,
    required super.updatedAt,
    required super.tags,
    super.imageUrl,
  });

  /// Factory constructor pour créer un BlogPostModel depuis JSON
  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags: List<String>.from(json['tags'] as List),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// Convertit le modèle en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }

  /// Méthode pour créer un BlogPostModel depuis une entité BlogPost
  factory BlogPostModel.fromEntity(BlogPost entity) {
    return BlogPostModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      author: entity.author,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      tags: entity.tags,
      imageUrl: entity.imageUrl,
    );
  }
}
