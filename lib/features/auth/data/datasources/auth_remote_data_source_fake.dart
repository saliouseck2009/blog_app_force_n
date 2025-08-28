import '../../../../core/config/storage/secure_storage.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';
import 'dart:convert';

/// Fake implementation of AuthRemoteDataSource for testing and development
class AuthRemoteDataSourceFake implements AuthRemoteDataSource {
  final SecureStorage _secureStorage;

  AuthRemoteDataSourceFake({required SecureStorage secureStorage})
    : _secureStorage = secureStorage;

  // Fake users database for simulation
  static final List<Map<String, dynamic>> _fakeUsers = [
    {
      'id': '1',
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@example.com',
      'password': 'password123',
      'createdAt': '2024-01-15T10:30:00Z',
      'updatedAt': '2024-08-27T14:20:00Z',
    },
    {
      'id': '2',
      'firstName': 'Jane',
      'lastName': 'Smith',
      'email': 'jane.smith@example.com',
      'password': 'securepass',
      'createdAt': '2024-02-20T09:15:00Z',
      'updatedAt': '2024-08-25T11:45:00Z',
    },
    {
      'id': '3',
      'firstName': 'Saliou',
      'lastName': 'Seck',
      'email': 'saliou@exemple.com',
      'password': 'admin123',
      'createdAt': '2024-03-10T16:00:00Z',
      'updatedAt': '2024-08-27T10:30:00Z',
    },
  ];

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Find user by email and password
    final user = _fakeUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Invalid credentials'),
    );

    // Generate fake tokens
    final fakeToken =
        'fake_jwt_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}';
    final fakeRefreshToken =
        'fake_refresh_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}';

    final response = {
      'success': true,
      'message': 'Login successful',
      'token': fakeToken,
      'refreshToken': fakeRefreshToken,
      'user': {
        'id': user['id'],
        'firstName': user['firstName'],
        'lastName': user['lastName'],
        'email': user['email'],
        'createdAt': user['createdAt'],
        'updatedAt': user['updatedAt'],
      },
    };

    // Sauvegarder les données d'authentification
    if (response['token'] != null && response['user'] != null) {
      final userData = response['user'] as Map<String, dynamic>;

      await _secureStorage.saveAuthData(
        token: response['token'] as String,
        refreshToken: (response['refreshToken'] ?? '') as String,
        userId: userData['id']?.toString() ?? '',
        userEmail: userData['email']?.toString() ?? '',
      );

      // Save complete user data
      await _secureStorage.saveCurrentUser(jsonEncode(userData));
    }

    return response;
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Check if user already exists
    final existingUser = _fakeUsers.where((u) => u['email'] == email);
    if (existingUser.isNotEmpty) {
      throw Exception('User with this email already exists');
    }

    // Create new user
    final newUserId = (_fakeUsers.length + 1).toString();
    final now = DateTime.now().toIso8601String();

    final newUser = {
      'id': newUserId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'createdAt': now,
      'updatedAt': now,
    };

    // Add to fake database
    _fakeUsers.add(newUser);

    // Generate fake tokens
    final fakeToken =
        'fake_jwt_token_${newUser['id']}_${DateTime.now().millisecondsSinceEpoch}';
    final fakeRefreshToken =
        'fake_refresh_token_${newUser['id']}_${DateTime.now().millisecondsSinceEpoch}';

    final response = {
      'success': true,
      'message': 'Account created successfully',
      'token': fakeToken,
      'refreshToken': fakeRefreshToken,
      'user': {
        'id': newUser['id'],
        'firstName': newUser['firstName'],
        'lastName': newUser['lastName'],
        'email': newUser['email'],
        'createdAt': newUser['createdAt'],
        'updatedAt': newUser['updatedAt'],
      },
    };

    // Sauvegarder les données d'authentification si l'inscription inclut la connexion
    if (response['token'] != null && response['user'] != null) {
      final userData = response['user'] as Map<String, dynamic>;

      await _secureStorage.saveAuthData(
        token: response['token'] as String,
        refreshToken: (response['refreshToken'] ?? '') as String,
        userId: userData['id']?.toString() ?? '',
        userEmail: userData['email']?.toString() ?? '',
      );

      // Save complete user data
      await _secureStorage.saveCurrentUser(jsonEncode(userData));
    }

    return response;
  }

  @override
  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate server logout (always successful in simulation)
    // In production, this would call: await _authService.logout();

    // Always clear local data
    await _secureStorage.clearAuthData();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Try to get user data from secure storage first
    final userJson = await _secureStorage.getCurrentUser();
    if (userJson != null && userJson.isNotEmpty) {
      final userData = jsonDecode(userJson);
      return UserModel.fromJson(userData);
    }

    // Check if there's a valid token to indicate user is logged in
    final token = await _secureStorage.getItem(key: SecureStorageKey.token);
    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user found. Please log in.');
    }

    // If there's a token but no user data, something went wrong
    throw Exception('User session corrupted. Please log in again.');
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // For simulation, always generate new tokens
    final userId = refreshToken.split(
      '_',
    )[3]; // Extract user ID from fake refresh token
    final newToken =
        'fake_jwt_token_${userId}_${DateTime.now().millisecondsSinceEpoch}';
    final newRefreshToken =
        'fake_refresh_token_${userId}_${DateTime.now().millisecondsSinceEpoch}';

    final response = {
      'success': true,
      'message': 'Token refreshed successfully',
      'token': newToken,
      'refreshToken': newRefreshToken,
    };

    // Mettre à jour le token
    if (response['token'] != null) {
      await _secureStorage.setItem(
        key: SecureStorageKey.token,
        value: response['token'] as String,
      );

      if (response['refreshToken'] != null) {
        await _secureStorage.setItem(
          key: SecureStorageKey.refreshToken,
          value: response['refreshToken'] as String,
        );
      }
    }

    return response;
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Get current user data from storage
    final userJson = await _secureStorage.getCurrentUser();
    if (userJson == null || userJson.isEmpty) {
      throw Exception('No user data found');
    }

    final currentUserData = jsonDecode(userJson);
    final userId = currentUserData['id'];

    // Update the user in fake database
    final userIndex = _fakeUsers.indexWhere((u) => u['id'] == userId);
    if (userIndex != -1) {
      _fakeUsers[userIndex] = {
        ..._fakeUsers[userIndex],
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Create updated user data without password
      final updatedUserData = Map<String, dynamic>.from(_fakeUsers[userIndex]);
      updatedUserData.remove('password');

      // Update local storage
      await _secureStorage.setItem(
        key: SecureStorageKey.userEmail,
        value: email,
      );
      await _secureStorage.saveCurrentUser(jsonEncode(updatedUserData));

      return UserModel.fromJson(updatedUserData);
    }

    throw Exception('User not found');
  }
}
