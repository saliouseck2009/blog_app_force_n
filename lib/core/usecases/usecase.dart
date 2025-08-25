import '../resources/data_state.dart';

/// Classe abstraite pour tous les cas d'usage
abstract class UseCase<T, Params> {
  Future<DataState<T>> call(Params params);
}

/// Classe pour les cas d'usage sans paramètres
class NoParams {
  const NoParams();
}
