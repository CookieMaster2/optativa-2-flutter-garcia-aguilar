import 'IConnection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Connection implements IConnection {
  @override
  Future<T> get<T>(String url, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body) as T;
  }

  @override
  Future<T> post<T, D>(String url, D data,
      {Map<String, String>? headers}) async {
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as T;
    }

    throw Exception('Error en la solicitud: ${response.statusCode}');
  }

  @override
  put<T, D>(String url, D data, {Map<String, String>? headers}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  delete<T>(String url, {Map<String, String>? headers}) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
