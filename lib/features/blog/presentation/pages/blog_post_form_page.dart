import 'package:flutter/material.dart';
import '../../models/blog_post.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
          _FormPageHeader(isEditMode: _isEditMode),
          Expanded(
            child: _FormContent(
              formKey: _formKey,
              titleController: _titleController,
              contentController: _contentController,
              authorController: _authorController,
              tagsController: _tagsController,
              isEditMode: _isEditMode,
            ),
          ),
          _FormActions(
            onSubmit: _handleSubmit,
            isEditMode: _isEditMode,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
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
        _showSuccessMessage();
        Navigator.pop(context);
      }
    }
  }

  void _showSuccessMessage() {
    final message = _isEditMode
        ? 'Post updated successfully!'
        : 'Post created successfully!';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}

class _FormPageHeader extends StatelessWidget {
  final bool isEditMode;

  const _FormPageHeader({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    final title = isEditMode ? 'Edit Post' : 'New Post';
    return PageHeader(title: title);
  }
}

class _FormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController authorController;
  final TextEditingController tagsController;
  final bool isEditMode;

  const _FormContent({
    required this.formKey,
    required this.titleController,
    required this.contentController,
    required this.authorController,
    required this.tagsController,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlogPostForm(
      formKey: formKey,
      titleController: titleController,
      contentController: contentController,
      authorController: authorController,
      tagsController: tagsController,
      isEdit: isEditMode,
    );
  }
}

class _FormActions extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool isEditMode;
  final bool isLoading;

  const _FormActions({
    required this.onSubmit,
    required this.isEditMode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = isEditMode ? 'Edit' : 'Save';

    return FormBottomSection(
      onPressed: onSubmit,
      buttonText: buttonText,
      isLoading: isLoading,
    );
  }
}
