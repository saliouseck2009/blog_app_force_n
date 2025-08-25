/// Classes pour gérer les états de données (Success/Failure)
/// Alternative à dartz Either&lt;Failure, T&gt;
abstract class DataState<T> {
  final T? data;
  final String? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(String error) : super(error: error);
}
