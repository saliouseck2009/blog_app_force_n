import '../../../../core/resources/data_state.dart';
import '../entities/user.dart';
import '../entities/auth_credentials.dart';

/// Repository abstrait pour l'authentification
abstract class AuthRepository {
  /// Connecter un utilisateur
  Future<DataState<User>> login(AuthCredentials credentials);

  /// Inscrire un nouvel utilisateur
  Future<DataState<User>> signUp(SignUpData signUpData);

  /// Déconnecter l'utilisateur actuel
  Future<DataState<void>> logout();

  /// Obtenir l'utilisateur actuellement connecté
  Future<DataState<User?>> getCurrentUser();

  /// Vérifier si un utilisateur est connecté
  Future<bool> isLoggedIn();

  /// Mettre à jour le profil utilisateur
  Future<DataState<User>> updateProfile(User user);
}
