import 'package:flutter/material.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/blog/presentation/pages/blog_list_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../injection_container.dart';
import 'resources/data_state.dart';
import 'usecases/usecase.dart';

/// Widget qui gère la navigation basée sur l'état d'authentification
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  final GetCurrentUserUseCase _getCurrentUserUseCase =
      sl<GetCurrentUserUseCase>();

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final dataState = await _getCurrentUserUseCase(NoParams());

      setState(() {
        _isAuthenticated = dataState is DataSuccess;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isAuthenticated ? const BlogListPage() : const LoginPage();
  }
}
