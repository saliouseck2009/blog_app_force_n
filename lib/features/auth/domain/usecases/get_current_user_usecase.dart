import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour obtenir l'utilisateur actuel
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  @override
  Future<DataState<User?>> call(NoParams params) {
    return _authRepository.getCurrentUser();
  }
}
