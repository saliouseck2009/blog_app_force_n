import 'dart:io';

import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'errors/network_exceptions.dart';
import 'interceptors/token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkingService {
  final Dio _dio;
  final SecureStorage _secureStorage;

  NetworkingService({required Dio dio, required SecureStorage secureStorage})
    : _dio = dio,
      _secureStorage = secureStorage {
    // Ajout des intercepteurs
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    _dio.interceptors.add(TokenInterceptor(_secureStorage));
  }

  /// Permet de changer dynamiquement le baseUrl si nécessaire.
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  // ===========================================================================
  // =============== Méthodes GET, POST, PUT, PATCH, DELETE, etc. ==============
  // ===========================================================================

  Future<Response> get(
    String endpoint, {
    bool requiresToken = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final mergedOptions = _mergeOptions(options, requiresToken);
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String endpoint, {
    bool requiresToken = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final mergedOptions = _mergeOptions(options, requiresToken);
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(
    String endpoint, {
    bool requiresToken = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final mergedOptions = _mergeOptions(options, requiresToken);
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> patch(
    String endpoint, {
    bool requiresToken = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final mergedOptions = _mergeOptions(options, requiresToken);
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(
    String endpoint, {
    bool requiresToken = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final mergedOptions = _mergeOptions(options, requiresToken);
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Options _mergeOptions(Options? originalOptions, bool requiresToken) {
    final newOptions = originalOptions ?? Options();
    final currentExtra = newOptions.extra;

    final safeExtra = currentExtra == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(currentExtra);

    safeExtra['requiresToken'] = requiresToken;

    newOptions.extra = safeExtra;

    return newOptions;
  }

  // ===========================================================================
  // ========================== GESTION DES ERREURS ============================
  // ===========================================================================
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ClientException("Le délai de connexion au serveur a expiré.");
      case DioExceptionType.sendTimeout:
        return ClientException("Le délai d'envoi de la requête a expiré.");
      case DioExceptionType.receiveTimeout:
        return ClientException("Le délai de réception de la réponse a expiré.");
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode == 401) {
          return AuthException(
            "Vous n'êtes pas autorisé à effectuer cette action (401).",
          );
        } else if (statusCode == 403) {
          return AuthException(
            "Accès refusé. Vous n'avez pas les droits nécessaires (403).",
          );
        } else if (statusCode == 404) {
          return NetworkException(
            "La ressource demandée est introuvable (404).",
            statusCode: statusCode,
          );
        } else if (statusCode == 500) {
          return ServerException(
            "Une erreur interne est survenue sur le serveur (500).",
            statusCode!,
          );
        } else {
          final message =
              _extractErrorMessage(responseData) ??
              "Une erreur s'est produite (code: $statusCode).";
          return NetworkException(message, statusCode: statusCode);
        }

      case DioExceptionType.badCertificate:
        return ClientException("Certificat SSL invalide ou inconnu.");

      case DioExceptionType.cancel:
        return ClientException("La requête a été annulée.");

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return InternetException(
            "Aucune connexion internet. Vérifiez votre réseau.",
          );
        }
        return NetworkException(
          e.message ?? "Une erreur inconnue s'est produite.",
        );
    }
  }

  /// Exemple d'extraction de message d'erreur depuis le body
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('error')) {
        if (responseData['error'] is String) {
          return responseData['error'] as String;
        }
        if (responseData['error'] is List) {
          return (responseData['error'] as List).join(', ');
        }
      }
      if (responseData.containsKey('message')) {
        if (responseData['message'] is String) {
          return responseData['message'] as String;
        }
        if (responseData['message'] is List) {
          return (responseData['message'] as List).join(', ');
        }
      }
      if (responseData.containsKey('ERROR_CODE')) {
        return responseData['ERROR_CODE'] as String;
      }
    }
    return null;
  }
}
