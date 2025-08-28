import 'package:flutter/material.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/usecases/delete_blog_post_usecase.dart';
import '../../domain/usecases/get_blog_post_by_id.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../injection_container.dart';

class BlogDetailPage extends StatefulWidget {
  final BlogPost blogPost;

  const BlogDetailPage({super.key, required this.blogPost});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  late BlogPost _currentBlogPost;
  bool _isLoading = false;

  final DeleteBlogPostUseCase _deleteBlogPostUseCase =
      sl<DeleteBlogPostUseCase>();
  final GetBlogPostById _getBlogPostByIdUseCase = sl<GetBlogPostById>();

  @override
  void initState() {
    super.initState();
    _currentBlogPost = widget.blogPost;
  }

  Future<void> _refreshBlogPost() async {
    setState(() {
      _isLoading = true;
    });

    final dataState = await _getBlogPostByIdUseCase(_currentBlogPost.id);

    if (dataState is DataSuccess<BlogPost>) {
      setState(() {
        _currentBlogPost = dataState.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBlogPost() async {
    final shouldDelete = await _showDeleteConfirmation();
    if (!shouldDelete) return;

    setState(() {
      _isLoading = true;
    });

    final dataState = await _deleteBlogPostUseCase(
      DeleteBlogPostParams(id: _currentBlogPost.id),
    );

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (dataState is DataSuccess) {
        _showSuccessMessage('Post deleted successfully!');
        Navigator.pop(
          context,
          true,
        ); // Retourner true pour indiquer une suppression
      } else if (dataState is DataFailed) {
        _showErrorMessage(dataState.error ?? 'Failed to delete post');
      }
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Post'),
            content: const Text(
              'Are you sure you want to delete this post? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _BlogDetailAppBar(
                blogPost: _currentBlogPost,
                onEdit: _handleEdit,
                onDelete: _deleteBlogPost,
                onRefresh: _refreshBlogPost,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BlogTitle(title: _currentBlogPost.title),
                      const SizedBox(height: 24),
                      _AuthorInfoSection(blogPost: _currentBlogPost),
                      const SizedBox(height: 32),
                      _ContentDivider(),
                      const SizedBox(height: 32),
                      _BlogContent(content: _currentBlogPost.content),
                      const SizedBox(height: 40),
                      if (_currentBlogPost.tags.isNotEmpty) ...[
                        _TagsSection(tags: _currentBlogPost.tags),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _handleEdit() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.blogForm,
      arguments: BlogPostFormPageArguments(blogPost: _currentBlogPost),
    );

    if (result == true) {
      _refreshBlogPost();
    }
  }
}

class _BlogDetailAppBar extends StatelessWidget {
  final BlogPost blogPost;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const _BlogDetailAppBar({
    required this.blogPost,
    required this.onEdit,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _CircularIconButton(
        icon: Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        _CircularIconButton(icon: Icons.refresh, onPressed: onRefresh),
        _CircularIconButton(icon: Icons.edit, onPressed: onEdit),
        _CircularIconButton(
          icon: Icons.delete,
          onPressed: onDelete,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _AppBarBackground(blogPost: blogPost),
      ),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const _CircularIconButton({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: backgroundColor != null ? Colors.white : Colors.black,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  final BlogPost blogPost;

  const _AppBarBackground({required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.indigo.shade50, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (blogPost.tags.isNotEmpty)
                _CategoryBadge(tag: blogPost.tags.first),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String tag;

  const _CategoryBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        tag.toUpperCase(),
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _BlogTitle extends StatelessWidget {
  final String title;

  const _BlogTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }
}

class _AuthorInfoSection extends StatelessWidget {
  final BlogPost blogPost;

  const _AuthorInfoSection({required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AuthorAvatar(authorName: blogPost.author),
        const SizedBox(width: 12),
        Expanded(child: _AuthorDetails(blogPost: blogPost)),
        _FollowButton(),
      ],
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  final String authorName;

  const _AuthorAvatar({required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.indigo.shade500],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getAuthorInitials(authorName),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getAuthorInitials(String authorName) {
    List<String> names = authorName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, 1).toUpperCase();
    }
    return 'A';
  }
}

class _AuthorDetails extends StatelessWidget {
  final BlogPost blogPost;

  const _AuthorDetails({required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AuthorName(authorName: blogPost.author),
        const SizedBox(height: 4),
        _PostMetadata(blogPost: blogPost),
      ],
    );
  }
}

class _AuthorName extends StatelessWidget {
  final String authorName;

  const _AuthorName({required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('By ', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          authorName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _PostMetadata extends StatelessWidget {
  final BlogPost blogPost;

  const _PostMetadata({required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetadataItem(
          icon: Icons.schedule,
          text: _formatDate(blogPost.createdAt),
        ),
        const SizedBox(width: 16),
        _MetadataItem(
          icon: Icons.access_time,
          text: _calculateReadTime(blogPost.content),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _calculateReadTime(String content) {
    final wordCount = content.split(' ').length;
    final readTimeMinutes = (wordCount / 200).ceil();
    return '$readTimeMinutes min read';
  }
}

class _MetadataItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetadataItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Follow',
        style: TextStyle(
          color: Colors.blue.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ContentDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.grey[200]);
  }
}

class _BlogContent extends StatelessWidget {
  final String content;

  const _BlogContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 18,
        height: 1.7,
        color: Colors.black87,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _TagsSection extends StatelessWidget {
  final List<String> tags;

  const _TagsSection({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TagsHeader(),
        const SizedBox(height: 16),
        _TagsList(tags: tags),
      ],
    );
  }
}

class _TagsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.local_offer_outlined, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _TagsList extends StatelessWidget {
  final List<String> tags;

  const _TagsList({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tags.map((tag) => _TagChip(tag: tag)).toList(),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
