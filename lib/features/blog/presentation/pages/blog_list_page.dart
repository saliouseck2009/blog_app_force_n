import 'package:flutter/material.dart';
import '../widgets/blog_post_card.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/usecases/get_all_blog_posts.dart';
import '../../domain/usecases/search_blog_posts_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../injection_container.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  List<BlogPost> _blogPosts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _isSearching = false;

  final GetAllBlogPosts _getAllBlogPostsUseCase = sl<GetAllBlogPosts>();
  final SearchBlogPostsUseCase _searchBlogPostsUseCase =
      sl<SearchBlogPostsUseCase>();

  @override
  void initState() {
    super.initState();
    _loadBlogPosts();
  }

  Future<void> _loadBlogPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final dataState = await _getAllBlogPostsUseCase(NoParams());

    if (dataState is DataSuccess<List<BlogPost>>) {
      setState(() {
        _blogPosts = dataState.data!;
        _isLoading = false;
      });
    } else if (dataState is DataFailed) {
      setState(() {
        _errorMessage = dataState.error!;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchBlogPosts(String query) async {
    if (query.isEmpty) {
      _loadBlogPosts();
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
    });

    final dataState = await _searchBlogPostsUseCase(
      SearchBlogPostsParams(query: query),
    );

    if (dataState is DataSuccess<List<BlogPost>>) {
      setState(() {
        _blogPosts = dataState.data!;
        _isSearching = false;
      });
    } else if (dataState is DataFailed) {
      setState(() {
        _errorMessage = dataState.error!;
        _isSearching = false;
      });
    }
  }

  Future<void> _refreshBlogPosts() async {
    if (_searchQuery.isEmpty) {
      await _loadBlogPosts();
    } else {
      await _searchBlogPosts(_searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _BlogListHeader(
              onSearch: _searchBlogPosts,
              isSearching: _isSearching,
            ),
            Expanded(
              child: _BlogListContent(
                blogPosts: _blogPosts,
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                onRefresh: _refreshBlogPosts,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _AddPostButton(onPostAdded: _loadBlogPosts),
    );
  }
}

class _BlogListHeader extends StatelessWidget {
  final Function(String) onSearch;
  final bool isSearching;

  const _BlogListHeader({required this.onSearch, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _TopBar(),
          const SizedBox(height: 16),
          _SearchBar(onSearch: onSearch, isSearching: isSearching),
        ],
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

class _SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final bool isSearching;

  const _SearchBar({required this.onSearch, required this.isSearching});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    widget.onSearch(query.trim());
  }

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
          Icon(
            widget.isSearching ? Icons.search : Icons.search,
            color: widget.isSearching ? Colors.blue : Colors.grey[500],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search blog posts',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: _handleSearch,
              onSubmitted: _handleSearch,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _handleSearch('');
              },
              child: Icon(Icons.clear, color: Colors.grey[500], size: 20),
            ),
        ],
      ),
    );
  }
}

class _BlogListContent extends StatelessWidget {
  final List<BlogPost> blogPosts;
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function() onRefresh;

  const _BlogListContent({
    required this.blogPosts,
    required this.isLoading,
    required this.errorMessage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Erreur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: blogPosts.isEmpty
          ? _EmptyState()
          : _BlogPostsList(blogPosts: blogPosts),
    );
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
  final VoidCallback onPostAdded;

  const _AddPostButton({required this.onPostAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.pushNamed(
          context,
          AppRoutes.blogForm,
          arguments:
              BlogPostFormPageArguments(), // Pas de blogPost = mode création
        );

        // Si un post a été créé, rafraîchir la liste
        if (result == true) {
          onPostAdded();
        }
      },
      tooltip: 'Ajouter un blog post',
      backgroundColor: Colors.blue[600],
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
