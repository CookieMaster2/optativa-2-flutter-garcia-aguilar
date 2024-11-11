import 'dart:convert';
import '../../../../infrastructure/app/repository.dart';
import '../../../../infrastructure/connection/connection.dart';
import '../dto/user_credentials.dart';
import '../dto/user_login_response.dart';

class LoginRepository
    implements Repository<UserLoginResponseDTO, UserCredentialsDTO> {
  final Connection _connection;
  final String url = "https://dummyjson.com/user/login";

  LoginRepository(this._connection);

  @override
  Future<UserLoginResponseDTO> execute(UserCredentialsDTO credentials) async {
    try {
      final requestBody = {
        'username': credentials.user,
        'password': credentials.password,
        'expiresInMins': 30,
      };

      //DEBUGGING
      print(
          "LoginRepository: Sending request to $url with body: ${jsonEncode(requestBody)} and headers: {'Content-Type': 'application/json'}");

      final response =
          await _connection.post<Map<String, dynamic>, Map<String, dynamic>>(
        url,
        requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      // DEBUGGING
      print("LoginRepository: Received response: $response");

      return UserLoginResponseDTO.fromJson(response);
    } catch (e) {
      //DEBUGGING
      print("LoginRepository: Error during login: $e");
      throw Exception('Error during login: $e');
    }
  }
}
