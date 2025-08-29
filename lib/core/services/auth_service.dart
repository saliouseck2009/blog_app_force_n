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


}
