import '../../../../core/resources/data_state.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implémentation mock du repository d'authentification
class AuthRepositoryImpl implements AuthRepository {
  // Simulation d'une base de données en mémoire
  static final Map<String, User> _users = {};
  static User? _currentUser;

  @override
  Future<DataState<User>> login(AuthCredentials credentials) async {
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 800));

      // Vérifier les identifiants
      final user = _users.values.firstWhere(
        (user) => user.email == credentials.email,
        orElse: () => throw Exception('User not found'),
      );

      // En production, vérifier le mot de passe hashé
      // Pour la démo, on accepte tout mot de passe
      _currentUser = user;

      return DataSuccess(user);
    } catch (e) {
      return DataFailed('Invalid email or password');
    }
  }

  @override
  Future<DataState<User>> signUp(SignUpData signUpData) async {
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 800));

      // Vérifier si l'email existe déjà
      if (_users.values.any((user) => user.email == signUpData.email)) {
        return DataFailed('Email already exists');
      }

      // Créer un nouvel utilisateur
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: signUpData.firstName,
        lastName: signUpData.lastName,
        email: signUpData.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Sauvegarder l'utilisateur
      _users[user.id] = user;
      _currentUser = user;

      return DataSuccess(user);
    } catch (e) {
      return DataFailed('Failed to create account');
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      // Simuler un délai
      await Future.delayed(const Duration(milliseconds: 300));

      _currentUser = null;
      return DataSuccess(null);
    } catch (e) {
      return DataFailed('Failed to logout');
    }
  }

  @override
  Future<DataState<User?>> getCurrentUser() async {
    try {
      // Simuler un délai
      await Future.delayed(const Duration(milliseconds: 200));

      return DataSuccess(_currentUser);
    } catch (e) {
      return DataFailed('Failed to get current user');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _currentUser != null;
  }

  @override
  Future<DataState<User>> updateProfile(User user) async {
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 600));

      // Mettre à jour l'utilisateur
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      _users[user.id] = updatedUser;

      if (_currentUser?.id == user.id) {
        _currentUser = updatedUser;
      }

      return DataSuccess(updatedUser);
    } catch (e) {
      return DataFailed('Failed to update profile');
    }
  }
}
