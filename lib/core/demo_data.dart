/// Classe simple pour les données de démonstration
class DemoBlogPost {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? imageUrl;

  const DemoBlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    this.imageUrl,
  });

  factory DemoBlogPost.fromJson(Map<String, dynamic> json) {
    return DemoBlogPost(
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
}

/// Données de démonstration
class DemoData {
  static List<Map<String, dynamic>> getBlogPosts() {
    return [
      {
        'id': 1,
        'title': 'Introduction à Flutter',
        'content':
            'Flutter est un framework de développement d\'applications mobiles créé par Google. Il permet de créer des applications natives pour iOS et Android avec un seul code source. Dans cet article, nous allons explorer les bases de Flutter et comprendre pourquoi il est devenu si populaire parmi les développeurs.',
        'author': 'John Doe',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
        'updatedAt': DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
        'tags': ['Flutter', 'Mobile', 'Dart'],
        'imageUrl': null,
      },
      {
        'id': 2,
        'title': 'Clean Architecture avec Flutter',
        'content':
            'La Clean Architecture est un pattern architectural qui sépare les préoccupations et rend le code plus maintenable. Dans ce post, nous verrons comment implémenter la Clean Architecture dans une application Flutter avec les couches Presentation, Domain et Data.',
        'author': 'Jane Smith',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
        'updatedAt': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
        'tags': ['Architecture', 'Flutter', 'Clean Code'],
        'imageUrl': null,
      },
      {
        'id': 3,
        'title': 'State Management avec BLoC',
        'content':
            'Le pattern BLoC (Business Logic Component) est l\'une des solutions de gestion d\'état les plus populaires dans Flutter. Il permet de séparer la logique métier de l\'interface utilisateur et facilite les tests.',
        'author': 'Bob Johnson',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'updatedAt': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'tags': ['BLoC', 'State Management', 'Flutter'],
        'imageUrl': null,
      },
      {
        'id': 4,
        'title': 'Tests automatisés en Flutter',
        'content':
            'Les tests sont essentiels pour maintenir la qualité du code. Flutter offre plusieurs types de tests : tests unitaires, tests de widgets et tests d\'intégration. Voyons comment les mettre en place.',
        'author': 'Alice Brown',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 12))
            .toIso8601String(),
        'updatedAt': DateTime.now()
            .subtract(const Duration(hours: 12))
            .toIso8601String(),
        'tags': ['Tests', 'Flutter', 'Qualité'],
        'imageUrl': null,
      },
    ];
  }
}
