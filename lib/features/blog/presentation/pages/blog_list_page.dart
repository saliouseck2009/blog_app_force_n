import 'package:flutter/material.dart';
import '../widgets/blog_post_card.dart';
import '../../../../core/routes/app_routes.dart';
import '../../models/blog_post.dart';

class BlogListPage extends StatelessWidget {
  const BlogListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _BlogListHeader(),
            Expanded(child: _BlogListContent()),
          ],
        ),
      ),
      floatingActionButton: _AddPostButton(),
    );
  }
}

class _BlogListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [_TopBar(), const SizedBox(height: 16), _SearchBar()],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfileAvatar(),
        const Spacer(),
        _AppTitle(),
        const Spacer(),
        const SizedBox(width: 40), // Balance l'avatar
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.profile);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person, color: Colors.blue[700], size: 24),
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Bloggr',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search blog posts',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demoPosts = _DemoBlogPosts();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: demoPosts.isEmpty
          ? _EmptyState()
          : _BlogPostsList(blogPosts: demoPosts()),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulation d'un rafraîchissement
    await Future.delayed(const Duration(seconds: 1));
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Aucun blog post trouvé', style: TextStyle(fontSize: 18)),
    );
  }
}

class _BlogPostsList extends StatelessWidget {
  final List<BlogPost> blogPosts;

  const _BlogPostsList({required this.blogPosts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: blogPosts.length,
      itemBuilder: (context, index) {
        final blogPost = blogPosts[index];
        return BlogPostCard(blogPost: blogPost);
      },
    );
  }
}

class _AddPostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.blogForm,
          arguments:
              BlogPostFormPageArguments(), // Pas de blogPost = mode création
        );
      },
      tooltip: 'Ajouter un blog post',
      backgroundColor: Colors.blue[600],
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

// Widget helper pour les données de démonstration
class _DemoBlogPosts {
  static List<BlogPost> get _demoBlogPosts => [
    BlogPost(
      id: 1,
      title: 'Introduction to Flutter Clean Architecture',
      content:
          'Flutter Clean Architecture is a powerful way to structure your Flutter applications...',
      author: 'John Doe',
      tags: ['Flutter', 'Architecture', 'Development'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    BlogPost(
      id: 2,
      title: 'Understanding State Management in Flutter',
      content:
          'State management is one of the most important concepts in Flutter development...',
      author: 'Jane Smith',
      tags: ['Flutter', 'State Management', 'BLoC'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BlogPost(
      id: 3,
      title: 'Building Responsive UIs with Flutter',
      content:
          'Creating responsive user interfaces is crucial for modern mobile applications...',
      author: 'John Doe',
      tags: ['Flutter', 'UI', 'Responsive Design'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<BlogPost> call() => _demoBlogPosts;
  bool get isEmpty => _demoBlogPosts.isEmpty;
}
