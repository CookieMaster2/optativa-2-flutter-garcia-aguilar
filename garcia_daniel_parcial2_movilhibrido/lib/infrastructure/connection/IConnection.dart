abstract class IConnection {
  get<T>(String url, {Map<String, String>? headers}) async {}

  post<T, D>(String url, D data, {Map<String, String>? headers}) async {}

  put<T, D>(String url, D data, {Map<String, String>? headers}) async {}

  delete<T>(String url, {Map<String, String>? headers}) async {}
}
