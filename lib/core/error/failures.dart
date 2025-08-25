import 'package:equatable/equatable.dart';

/// Classe abstraite représentant les échecs dans l'application
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Échec général du serveur
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Échec de cache/stockage local
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Échec de réseau
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
