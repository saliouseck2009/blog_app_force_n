import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implémentation du repository d'authentification avec networking
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<User> login(AuthCredentials credentials) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<User> signUp(SignUpData signUpData) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
