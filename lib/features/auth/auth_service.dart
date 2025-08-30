import 'dart:convert';

import 'package:blog_app/features/auth/models/auth_credentials.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = '172.20.10.2:3000';

class AuthService {
  Map<String, String> apiHeaders = {
    'Content-Type': 'application/json',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept': 'application/json',
    'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
  };

  Future<SignUpResponse> signUp(SignUpData data) async {
    var url = Uri.http(baseUrl, '/api/auth/register');
    var response = await http.post(
      url,
      headers: apiHeaders,
      body: jsonEncode(data.toJson()),
    );
    if (response.statusCode == 201) {
      final signUpResponse = SignUpResponse.fromJson(
        json.decode(response.body),
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', signUpResponse.token);

      return signUpResponse;
    } else {
      throw Exception('Failed to sign up');
    }
  }
}
