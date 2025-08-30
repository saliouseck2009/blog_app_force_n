import '../entities/user.dart';
import '../entities/auth_credentials.dart';

/// Repository abstrait pour l'authentification
abstract class AuthRepository {
  /// Connecter un utilisateur
  Future<User> login(AuthCredentials credentials);

  /// Inscrire un nouvel utilisateur
  Future<User> signUp(SignUpData signUpData);
}
