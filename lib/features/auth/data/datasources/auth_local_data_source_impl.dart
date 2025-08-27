import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/storage/secure_storage.dart';
import '../models/user_model.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  static const String _cachedUserKey = 'cached_user';

  AuthLocalDataSourceImpl({
    required SecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _secureStorage = secureStorage,
       _sharedPreferences = sharedPreferences;

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(_cachedUserKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      // En cas d'erreur de désérialisation, retourner null
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _sharedPreferences.setString(_cachedUserKey, userJson);
  }

  @override
  Future<void> removeCachedUser() async {
    await _sharedPreferences.remove(_cachedUserKey);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await _secureStorage.isLoggedIn();
  }

  @override
  Future<String?> getAuthToken() async {
    return await _secureStorage.getToken();
  }

  @override
  Future<void> clearAuthData() async {
    await Future.wait([_secureStorage.clearAuthData(), removeCachedUser()]);
  }
}
