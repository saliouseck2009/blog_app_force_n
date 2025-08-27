import 'dart:convert';

import '../../../../core/resources/data_state.dart';
import '../../../../core/config/network/errors/network_exceptions.dart';
import '../../../../core/config/storage/secure_storage.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

/// Implémentation du repository d'authentification avec networking
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage;

  @override
  Future<DataState<User>> login(AuthCredentials credentials) async {
    try {
      final response = await _remoteDataSource.login(
        email: credentials.email,
        password: credentials.password,
      );

      if (response['user'] != null) {
        final userModel = UserModel.fromJson(response['user']);

        // Sauvegarder l'utilisateur connecté dans le stockage sécurisé
        await _secureStorage.saveCurrentUser(jsonEncode(userModel.toJson()));

        return DataSuccess(userModel);
      } else {
        return DataFailed('Données utilisateur manquantes');
      }
    } on AuthException catch (e) {
      return DataFailed(e.message);
    } on NetworkException catch (e) {
      return DataFailed(e.message);
    } catch (e) {
      return DataFailed('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<DataState<User>> signUp(SignUpData signUpData) async {
    try {
      final response = await _remoteDataSource.signUp(
        firstName: signUpData.firstName,
        lastName: signUpData.lastName,
        email: signUpData.email,
        password: signUpData.password,
      );

      if (response['user'] != null) {
        final userModel = UserModel.fromJson(response['user']);

        // Sauvegarder l'utilisateur connecté dans le stockage sécurisé
        await _secureStorage.saveCurrentUser(jsonEncode(userModel.toJson()));

        return DataSuccess(userModel);
      } else {
        return DataFailed('Échec de l\'inscription');
      }
    } on AuthException catch (e) {
      return DataFailed(e.message);
    } on NetworkException catch (e) {
      return DataFailed(e.message);
    } catch (e) {
      return DataFailed('Erreur d\'inscription: ${e.toString()}');
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      await _remoteDataSource.logout();

      // Nettoyer toutes les données d'authentification du stockage sécurisé
      await _secureStorage.clearAuthData();

      return DataSuccess(null);
    } catch (e) {
      return DataFailed('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }

  @override
  Future<DataState<User?>> getCurrentUser() async {
    try {
      // D'abord essayer de récupérer l'utilisateur depuis le stockage local
      final userJson = await _secureStorage.getCurrentUser();

      if (userJson != null && userJson.isNotEmpty) {
        final userModel = UserModel.fromJson(jsonDecode(userJson));
        return DataSuccess(userModel);
      }

      // Aucun utilisateur trouvé
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        'Impossible de récupérer les données utilisateur: ${e.toString()}',
      );
    }
  }
}
