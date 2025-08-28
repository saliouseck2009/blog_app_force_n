import '../../../../core/services/auth_service.dart';
import '../../../../core/config/storage/secure_storage.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';
import 'dart:convert';

/// Real implementation of AuthRemoteDataSource that makes actual API calls
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
      final userData = response['user'] as Map<String, dynamic>;

      await _secureStorage.saveAuthData(
        token: response['token'] as String,
        refreshToken: (response['refreshToken'] ?? '') as String,
        userId: userData['id']?.toString() ?? '',
        userEmail: userData['email']?.toString() ?? '',
      );

      // Save complete user data
      await _secureStorage.saveCurrentUser(jsonEncode(userData));
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
      final userData = response['user'] as Map<String, dynamic>;

      await _secureStorage.saveAuthData(
        token: response['token'] as String,
        refreshToken: (response['refreshToken'] ?? '') as String,
        userId: userData['id']?.toString() ?? '',
        userEmail: userData['email']?.toString() ?? '',
      );

      // Save complete user data
      await _secureStorage.saveCurrentUser(jsonEncode(userData));
    }

    return response;
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      // Toujours supprimer les données locales même en cas d'erreur serveur
      await _secureStorage.clearAuthData();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _authService.getCurrentUser();
    return UserModel.fromJson(response['user'] ?? response);
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _authService.refreshToken(refreshToken);

    // Mettre à jour le token
    if (response['token'] != null) {
      await _secureStorage.setItem(
        key: SecureStorageKey.token,
        value: response['token'] as String,
      );

      if (response['refreshToken'] != null) {
        await _secureStorage.setItem(
          key: SecureStorageKey.refreshToken,
          value: response['refreshToken'] as String,
        );
      }
    }

    return response;
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final response = await _authService.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );

    // Mettre à jour l'email stocké localement
    await _secureStorage.setItem(key: SecureStorageKey.userEmail, value: email);

    return UserModel.fromJson(response['user'] ?? response);
  }
}
