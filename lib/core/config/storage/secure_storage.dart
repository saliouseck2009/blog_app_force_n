import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageKey {
  static const String token = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String isLoggedIn = 'is_logged_in';
  static const String currentUser = 'current_user';
}

class SecureStorage {
  static const _secureStorage = FlutterSecureStorage();

  /// Sauvegarder un élément de manière sécurisée
  Future<void> setItem({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Récupérer un élément sécurisé
  Future<String?> getItem({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  /// Supprimer un élément sécurisé
  Future<void> removeItem({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  /// Supprimer tous les éléments sécurisés
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }

  /// Vérifier si un élément existe
  Future<bool> containsKey({required String key}) async {
    return await _secureStorage.containsKey(key: key);
  }

  /// Récupérer toutes les clés
  Future<Map<String, String>> getAllItems() async {
    return await _secureStorage.readAll();
  }

  // Méthodes spécifiques pour l'authentification
  Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    required String userId,
    required String userEmail,
  }) async {
    await Future.wait([
      setItem(key: SecureStorageKey.token, value: token),
      setItem(key: SecureStorageKey.refreshToken, value: refreshToken),
      setItem(key: SecureStorageKey.userId, value: userId),
      setItem(key: SecureStorageKey.userEmail, value: userEmail),
      setItem(key: SecureStorageKey.isLoggedIn, value: 'true'),
    ]);
  }

  Future<void> clearAuthData() async {
    await Future.wait([
      removeItem(key: SecureStorageKey.token),
      removeItem(key: SecureStorageKey.refreshToken),
      removeItem(key: SecureStorageKey.userId),
      removeItem(key: SecureStorageKey.userEmail),
      removeItem(key: SecureStorageKey.isLoggedIn),
      removeItem(key: SecureStorageKey.currentUser),
    ]);
  }

  Future<String?> getToken() async {
    return await getItem(key: SecureStorageKey.token);
  }

  Future<String?> getRefreshToken() async {
    return await getItem(key: SecureStorageKey.refreshToken);
  }

  Future<bool> isLoggedIn() async {
    final isLoggedIn = await getItem(key: SecureStorageKey.isLoggedIn);
    return isLoggedIn == 'true';
  }

  /// Sauvegarder l'utilisateur connecté
  Future<void> saveCurrentUser(String userJson) async {
    await setItem(key: SecureStorageKey.currentUser, value: userJson);
  }

  /// Récupérer l'utilisateur connecté
  Future<String?> getCurrentUser() async {
    return await getItem(key: SecureStorageKey.currentUser);
  }
}
