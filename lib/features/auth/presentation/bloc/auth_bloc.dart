import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC pour la gestion de l'authentification
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthRepository authRepository,
  }) : _loginUseCase = loginUseCase,
       _signUpUseCase = signUpUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _authRepository = authRepository,
       super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  /// Gestion de la connexion
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _loginUseCase.call(event.credentials);

    if (result is DataSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else if (result is DataFailed) {
      emit(AuthError(result.error!));
    }
  }

  /// Gestion de l'inscription
  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _signUpUseCase.call(event.signUpData);

    if (result is DataSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else if (result is DataFailed) {
      emit(AuthError(result.error!));
    }
  }

  /// Gestion de la déconnexion
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _authRepository.logout();

    if (result is DataSuccess) {
      emit(const AuthUnauthenticated());
    } else if (result is DataFailed) {
      emit(AuthError(result.error!));
    }
  }

  /// Vérification du statut d'authentification
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _getCurrentUserUseCase.call(const NoParams());

    if (result is DataSuccess) {
      final user = result.data;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else if (result is DataFailed) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Mise à jour du profil
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(const AuthLoading());

      final result = await _authRepository.updateProfile(event.user);

      if (result is DataSuccess) {
        emit(AuthAuthenticated(result.data!));
      } else if (result is DataFailed) {
        emit(AuthError(result.error!));
        // Restaurer l'état précédent en cas d'erreur
        emit(currentState);
      }
    }
  }
}
