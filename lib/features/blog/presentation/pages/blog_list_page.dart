import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import '../widgets/blog_post_card.dart';
import 'blog_post_form_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';

class BlogListPage extends StatelessWidget {
  const BlogListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header personnalisé
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top bar avec avatar et titre
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.blue[700],
                            size: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Bloggr',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40), // Balance l'avatar
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Barre de recherche
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: BlocBuilder<BlogBloc, BlogState>(
                builder: (context, state) {
                  if (state is BlogInitial) {
                    // Déclencer le chargement initial
                    context.read<BlogBloc>().add(GetAllBlogPostsEvent());
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BlogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BlogLoaded) {
                    if (state.blogPosts.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucun blog post trouvé',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<BlogBloc>().add(RefreshBlogPostsEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: state.blogPosts.length,
                        itemBuilder: (context, index) {
                          final blogPost = state.blogPosts[index];
                          return BlogPostCard(blogPost: blogPost);
                        },
                      ),
                    );
                  } else if (state is BlogError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<BlogBloc>().add(
                                GetAllBlogPostsEvent(),
                              );
                            },
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const BlogPostFormPage(), // Pas de blogPost = mode création
            ),
          );
        },
        tooltip: 'Ajouter un blog post',
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
