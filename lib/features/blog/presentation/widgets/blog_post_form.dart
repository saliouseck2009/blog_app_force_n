import 'package:flutter/material.dart';
import 'custom_text_field.dart';

/// Widget pour le formulaire de blog post
class BlogPostForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController authorController;
  final TextEditingController tagsController;
  final bool isEdit;

  const BlogPostForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.contentController,
    required this.authorController,
    required this.tagsController,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TitleField(controller: titleController, isEdit: isEdit),
            const SizedBox(height: 16),
            AuthorField(controller: authorController),
            const SizedBox(height: 16),
            ContentField(controller: contentController, isEdit: isEdit),
            const SizedBox(height: 16),
            TagsField(controller: tagsController),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Widget pour le champ titre
class TitleField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEdit;

  const TitleField({super.key, required this.controller, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: isEdit ? 'Title of the first blog' : 'Title',
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }
}

/// Widget pour le champ auteur
class AuthorField extends StatelessWidget {
  final TextEditingController controller;

  const AuthorField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Author',
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an author';
        }
        return null;
      },
    );
  }
}

/// Widget pour le champ contenu
class ContentField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEdit;

  const ContentField({
    super.key,
    required this.controller,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: isEdit ? 'Content of the first blog' : 'Content',
      controller: controller,
      maxLines: 8,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter content';
        }
        return null;
      },
    );
  }
}

/// Widget pour le champ tags
class TagsField extends StatelessWidget {
  final TextEditingController controller;

  const TagsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Tags (separated by commas)',
          controller: controller,
        ),
        const SizedBox(height: 8),
        TagsHelpText(),
      ],
    );
  }
}

/// Widget pour le texte d'aide des tags
class TagsHelpText extends StatelessWidget {
  const TagsHelpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Example: flutter, mobile, development',
      style: TextStyle(color: Colors.grey[600], fontSize: 12),
    );
  }
}
