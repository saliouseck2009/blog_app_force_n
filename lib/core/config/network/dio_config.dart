import 'package:dio/dio.dart';

const baseUrl = "http://localhost:3000";

final dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ),
);

class ApiEndpoints {
  // Auth endpoints
  static const String login = "/auth/login";
  static const String signUp = "/auth/signup";
  static const String logout = "/auth/logout";
  static const String refreshToken = "/auth/refresh";
  static const String currentUser = "/auth/me";

  // Blog endpoints
  static const String blogs = "/blogs";
  static String blogById(int id) => "/blogs/$id";
}
