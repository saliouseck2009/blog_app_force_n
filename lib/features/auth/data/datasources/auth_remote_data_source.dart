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
}
