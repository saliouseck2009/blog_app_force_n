/// Classe pour les données d'authentification
class AuthCredentials {
  final String email;
  final String password;

  const AuthCredentials({required this.email, required this.password});
}

/// Classe pour les données d'inscription
class SignUpData {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const SignUpData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}
