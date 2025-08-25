import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_credentials.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour la connexion
class LoginUseCase implements UseCase<User, AuthCredentials> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<DataState<User>> call(AuthCredentials params) {
    return _authRepository.login(params);
  }
}
