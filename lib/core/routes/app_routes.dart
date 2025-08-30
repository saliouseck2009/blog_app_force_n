import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/blog/presentation/pages/blog_list_page.dart';
import '../../features/blog/presentation/pages/blog_detail_page.dart';
import '../../features/blog/presentation/pages/blog_post_form_page.dart';
import '../../features/blog/models/blog_post.dart';

/// Arguments pour la page de détail de blog
class BlogDetailPageArguments {
  final BlogPost blogPost;

  BlogDetailPageArguments({required this.blogPost});
}

/// Arguments pour la page de formulaire de blog
class BlogPostFormPageArguments {
  final BlogPost? blogPost; // null pour création, objet pour édition

  BlogPostFormPageArguments({this.blogPost});
}

/// Gestion centralisée des routes de l'application
class AppRoutes {
  // Route names
  static const String login = '/';
  static const String signUp = '/signup';
  static const String blogList = '/blog-list';
  static const String blogDetail = '/blog-detail';
  static const String blogForm = '/blog-form';
  static const String profile = '/profile';

  /// Générateur de routes principal
  static Route onGenerateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case login:
        return _materialRoute(view: const LoginPage(), settings: settings);

      case signUp:
        return _materialRoute(view: const SignUpPage(), settings: settings);

      case blogList:
        return _materialRoute(view: const BlogListPage(), settings: settings);

      case blogDetail:
        if (args is BlogDetailPageArguments) {
          return _materialRoute(
            view: BlogDetailPage(blogPost: args.blogPost),
            settings: settings,
          );
        } else {
          return _errorRoute(settings);
        }

      case blogForm:
        if (args is BlogPostFormPageArguments) {
          return _materialRoute(
            view: BlogPostFormPage(blogPost: args.blogPost),
            settings: settings,
          );
        } else {
          return _materialRoute(
            view: const BlogPostFormPage(),
            settings: settings,
          );
        }

      case profile:
        return _materialRoute(view: const ProfilePage(), settings: settings);

      default:
        return _errorRoute(settings);
    }
  }

  /// Crée une route Material standard
  static Route<dynamic> _materialRoute({
    required Widget view,
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(settings: settings, builder: (_) => view);
  }

  /// Route d'erreur pour les routes non trouvées
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Error"),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  "Page not found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Route: ${settings.name}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    login,
                    (route) => false,
                  ),
                  child: const Text("Go to Login"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
