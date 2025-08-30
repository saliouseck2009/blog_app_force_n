import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service Locator global
final sl = GetIt.instance;

/// Configuration de l'injection de dépendances
Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
