import 'package:flutter/material.dart';

/// Widget de header de page personnalisé
class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const PageHeader({super.key, required this.title, this.onClose});

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onClose ?? () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              style: IconButton.styleFrom(foregroundColor: Colors.grey[700]),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 48), // Balance the close button
          ],
        ),
      ),
    );
  }
}
