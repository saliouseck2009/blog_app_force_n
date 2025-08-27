import '../config/network/networking_service.dart';
import '../config/network/dio_config.dart';

class AuthService {
  final NetworkingService _networkingService;

  AuthService(this._networkingService);

  /// Connexion de l'utilisateur
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _networkingService.post(
      ApiEndpoints.login,
      requiresToken: false,
      data: {'email': email, 'password': password},
    );

    return response.data;
  }

  /// Inscription de l'utilisateur
  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _networkingService.post(
      ApiEndpoints.signUp,
      requiresToken: false,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );

    return response.data;
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    await _networkingService.post(ApiEndpoints.logout, requiresToken: true);
  }

  /// Récupération des informations de l'utilisateur actuel
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _networkingService.get(
      ApiEndpoints.currentUser,
      requiresToken: true,
    );

    return response.data;
  }

  /// Rafraîchissement du token d'authentification
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _networkingService.post(
      ApiEndpoints.refreshToken,
      requiresToken: false,
      data: {'refreshToken': refreshToken},
    );

    return response.data;
  }

  /// Mise à jour du profil utilisateur
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final response = await _networkingService.put(
      ApiEndpoints.currentUser,
      requiresToken: true,
      data: {'firstName': firstName, 'lastName': lastName, 'email': email},
    );

    return response.data;
  }
}
