import '../models/user_model.dart';

/// Interface pour la source de données distante de l'authentification
abstract class AuthRemoteDataSource {
  /// Connexion de l'utilisateur
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Inscription de l'utilisateur
  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  /// Déconnexion de l'utilisateur
  Future<void> logout();

  /// Récupération des informations de l'utilisateur actuel
  Future<UserModel> getCurrentUser();

  /// Rafraîchissement du token d'authentification
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  /// Mise à jour du profil utilisateur
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  });
}
