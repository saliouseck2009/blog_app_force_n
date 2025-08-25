import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// États d'authentification
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// État initial
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// État de chargement
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// État d'utilisateur connecté
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// État d'utilisateur non connecté
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// État d'erreur
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
