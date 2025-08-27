/// Exception pour les erreurs réseau
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    return 'NetworkException: $message${statusCode != null ? ' (code: $statusCode)' : ''}';
  }
}

/// Exception pour les erreurs client (pas de connexion internet)
class ClientException implements Exception {
  final String message;

  ClientException(this.message);

  @override
  String toString() {
    return 'ClientException: $message';
  }
}

/// Exception pour les erreurs internet
class InternetException implements Exception {
  final String message;

  InternetException(this.message);

  @override
  String toString() {
    return 'InternetException: $message';
  }
}

/// Exception pour les erreurs serveur
class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException(this.message, this.statusCode);

  @override
  String toString() {
    return 'ServerException: $message (code: $statusCode)';
  }
}

/// Exception pour les erreurs d'authentification
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return 'AuthException: $message';
  }
}
