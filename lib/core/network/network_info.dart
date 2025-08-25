/// Interface pour vérifier la connectivité réseau
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
