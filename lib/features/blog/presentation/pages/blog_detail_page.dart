import 'package:flutter/material.dart';
import '../../models/blog_post.dart';
import '../../../../core/routes/app_routes.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogPost blogPost;

  const BlogDetailPage({super.key, required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _BlogDetailAppBar(blogPost: blogPost),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BlogTitle(title: blogPost.title),
                  const SizedBox(height: 24),
                  _AuthorInfoSection(blogPost: blogPost),
                  const SizedBox(height: 32),
                  _ContentDivider(),
                  const SizedBox(height: 32),
                  _BlogContent(content: blogPost.content),
                  const SizedBox(height: 40),
                  if (blogPost.tags.isNotEmpty) ...[
                    _TagsSection(tags: blogPost.tags),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogDetailAppBar extends StatelessWidget {
  final BlogPost blogPost;

  const _BlogDetailAppBar({required this.blogPost});

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
        _CircularIconButton(
          icon: Icons.edit,
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.blogForm,
              arguments: BlogPostFormPageArguments(blogPost: blogPost),
            );
          },
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

  const _CircularIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
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
        icon: Icon(icon, color: Colors.black),
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
