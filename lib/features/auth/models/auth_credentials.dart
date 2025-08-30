/// Classe pour les données d'authentification
library;

class AuthCredentials {
  final String email;
  final String password;

  const AuthCredentials({required this.email, required this.password});
}

class SignUpData {
  String nom;
  String prenom;
  String email;
  String motDePasse;

  SignUpData({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
  });

  Map<String, dynamic> toJson() => {
    "nom": nom,
    "prenom": prenom,
    "email": email,
    "motDePasse": motDePasse,
  };
}

class SignUpResponse {
  User user;
  String token;

  SignUpResponse({required this.user, required this.token});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      SignUpResponse(user: User.fromJson(json["user"]), token: json["token"]);
}

class User {
  int id;
  String nom;
  String prenom;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    nom: json["nom"],
    prenom: json["prenom"],
    email: json["email"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}
