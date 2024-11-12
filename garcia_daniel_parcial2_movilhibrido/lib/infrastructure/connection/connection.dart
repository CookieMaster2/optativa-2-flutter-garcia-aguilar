import 'IConnection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Connection implements IConnection {
  @override
  Future<T> get<T>(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as T;
      } else {
        throw Exception('No se pudo realizar GET: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de solicitud GET: $e');
    }
  }

  @override
  Future<T> post<T, D>(String url, D data, {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as T;
      } else {
        throw Exception('No se pudo realizar POST: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de solicitud POST: $e');
    }
  }

  @override
  delete<T>(String url, {Map<String, String>? headers}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  put<T, D>(String url, D data, {Map<String, String>? headers}) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
