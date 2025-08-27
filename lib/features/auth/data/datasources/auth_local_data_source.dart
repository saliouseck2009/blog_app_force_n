import '../models/user_model.dart';

/// Interface pour la source de données locale de l'authentification
abstract class AuthLocalDataSource {
  /// Récupérer l'utilisateur en cache
  Future<UserModel?> getCachedUser();

  /// Mettre en cache l'utilisateur
  Future<void> cacheUser(UserModel user);

  /// Supprimer l'utilisateur du cache
  Future<void> removeCachedUser();

  /// Vérifier si l'utilisateur est connecté localement
  Future<bool> isUserLoggedIn();

  /// Récupérer le token d'authentification
  Future<String?> getAuthToken();

  /// Supprimer toutes les données d'authentification
  Future<void> clearAuthData();
}
