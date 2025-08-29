import '../../../../core/services/auth_service.dart';
import '../../../../core/config/storage/secure_storage.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;
  final SecureStorage _secureStorage;

  AuthRemoteDataSourceImpl({
    required AuthService authService,
    required SecureStorage secureStorage,
  }) : _authService = authService,
       _secureStorage = secureStorage;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _authService.login(email: email, password: password);

    // Sauvegarder les données d'authentification
    if (response['token'] != null && response['user'] != null) {
      await _secureStorage.saveAuthData(
        token: response['token'],
        refreshToken: response['refreshToken'] ?? '',
        userId: response['user']['id']?.toString() ?? '',
        userEmail: response['user']['email'] ?? '',
      );
    }

    return response;
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _authService.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    // Sauvegarder les données d'authentification si l'inscription inclut la connexion
    if (response['token'] != null && response['user'] != null) {
      await _secureStorage.saveAuthData(
        token: response['token'],
        refreshToken: response['refreshToken'] ?? '',
        userId: response['user']['id']?.toString() ?? '',
        userEmail: response['user']['email'] ?? '',
      );
    }

    return response;
  }


}
