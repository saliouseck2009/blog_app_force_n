import 'package:equatable/equatable.dart';

/// Entité User pour la couche Domain
class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Nom complet de l'utilisateur
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    profileImageUrl,
    createdAt,
    updatedAt,
  ];

  /// Copie avec modifications
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
