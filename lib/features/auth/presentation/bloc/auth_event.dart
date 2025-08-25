import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user.dart';

/// Événements d'authentification
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Événement de connexion
class LoginEvent extends AuthEvent {
  final AuthCredentials credentials;

  const LoginEvent(this.credentials);

  @override
  List<Object> get props => [credentials];
}

/// Événement d'inscription
class SignUpEvent extends AuthEvent {
  final SignUpData signUpData;

  const SignUpEvent(this.signUpData);

  @override
  List<Object> get props => [signUpData];
}

/// Événement de déconnexion
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Événement de vérification du statut d'authentification
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Événement de mise à jour du profil
class UpdateProfileEvent extends AuthEvent {
  final User user;

  const UpdateProfileEvent(this.user);

  @override
  List<Object> get props => [user];
}
