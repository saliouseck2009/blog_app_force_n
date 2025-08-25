import 'package:flutter/material.dart';
import '../../domain/entities/blog_post.dart';
import '../widgets/page_header.dart';
import '../widgets/blog_post_form.dart';
import '../widgets/form_bottom_section.dart';

/// Page unifiée pour créer ou éditer un blog post
class BlogPostFormPage extends StatefulWidget {
  final BlogPost? blogPost; // null pour création, objet pour édition

  const BlogPostFormPage({super.key, this.blogPost});

  @override
  State<BlogPostFormPage> createState() => _BlogPostFormPageState();
}

class _BlogPostFormPageState extends State<BlogPostFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _authorController;
  late final TextEditingController _tagsController;

  bool _isLoading = false;

  /// Retourne true si on est en mode édition
  bool get _isEditMode => widget.blogPost != null;

  /// Retourne le titre de la page
  String get _pageTitle => _isEditMode ? 'Edit Post' : 'New Post';

  /// Retourne le texte du bouton
  String get _buttonText => _isEditMode ? 'Edit' : 'Save';

  /// Retourne le message de succès
  String get _successMessage =>
      _isEditMode ? 'Post updated successfully!' : 'Post created successfully!';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(
      text: widget.blogPost?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.blogPost?.content ?? '',
    );
    _authorController = TextEditingController(
      text: widget.blogPost?.author ?? '',
    );

    // Convertir les tags en string séparés par des virgules
    String tagsText = '';
    final tags = widget.blogPost?.tags;
    if (tags != null) {
      tagsText = tags.join(', ');
    }
    _tagsController = TextEditingController(text: tagsText);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PageHeader(title: _pageTitle),
          Expanded(
            child: BlogPostForm(
              formKey: _formKey,
              titleController: _titleController,
              contentController: _contentController,
              authorController: _authorController,
              tagsController: _tagsController,
              isEdit: _isEditMode,
            ),
          ),
          FormBottomSection(
            onPressed: _handleSubmit,
            buttonText: _buttonText,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simuler un délai de traitement
      await Future.delayed(const Duration(milliseconds: 800));

      // TODO: Implémenter la logique de sauvegarde/édition
      // final tags = _tagsController.text
      //     .split(',')
      //     .map((tag) => tag.trim())
      //     .where((tag) => tag.isNotEmpty)
      //     .toList();

      // if (_isEditMode) {
      //   context.read<BlogBloc>().add(
      //     EditBlogPostEvent(
      //       id: widget.blogPost.id,
      //       title: _titleController.text.trim(),
      //       content: _contentController.text.trim(),
      //       author: _authorController.text.trim(),
      //       tags: tags,
      //     ),
      //   );
      // } else {
      //   context.read<BlogBloc>().add(
      //     AddBlogPostEvent(
      //       title: _titleController.text.trim(),
      //       content: _contentController.text.trim(),
      //       author: _authorController.text.trim(),
      //       tags: tags,
      //     ),
      //   );
      // }

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_successMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
