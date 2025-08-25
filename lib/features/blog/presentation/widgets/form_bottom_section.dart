import 'package:flutter/material.dart';
import 'action_button.dart';

/// Widget pour la section bottom avec le bouton d'action
class FormBottomSection extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool isLoading;

  const FormBottomSection({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ActionButton(
          text: buttonText,
          onPressed: onPressed,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
