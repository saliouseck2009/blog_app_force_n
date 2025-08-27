import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final String tokenKey;

  TokenInterceptor(
    this._secureStorage, {
    this.tokenKey = SecureStorageKey.token,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Vérifie si la requête nécessite un token
    final requiresToken = options.extra['requiresToken'] == true;
    if (requiresToken) {
      // Récupère le token dans les préférences
      final token = await _secureStorage.getItem(key: tokenKey);

      if (token == null || token.isEmpty) {
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: 'Token manquant',
          ),
        );
      } else {
        // Ajouter le token au header
        options.headers["Authorization"] = "Bearer $token";
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Gestion du refresh token en cas d'erreur 401
    if (err.response?.statusCode == 401) {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        // Tenter de rafraîchir le token
        try {
          // TODO: Implémenter le refresh token avec l'API
          // final newToken = await refreshAuthToken(refreshToken);
          // await _secureStorage.setItem(key: tokenKey, value: newToken);
          // Relancer la requête avec le nouveau token

          // Pour l'instant, on passe l'erreur
          super.onError(err, handler);
        } catch (e) {
          // Échec du refresh, déconnecter l'utilisateur
          await _secureStorage.clearAuthData();
          super.onError(err, handler);
        }
      } else {
        // Pas de refresh token, déconnecter l'utilisateur
        await _secureStorage.clearAuthData();
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
