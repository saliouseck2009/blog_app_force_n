import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_credentials.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour l'inscription
class SignUpUseCase implements UseCase<User, SignUpData> {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  @override
  Future<DataState<User>> call(SignUpData params) {
    return _authRepository.signUp(params);
  }
}
