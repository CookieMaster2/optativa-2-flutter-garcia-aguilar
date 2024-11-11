import '../../../infrastructure/app/localstorage.dart';
import '../../../infrastructure/app/use_case.dart';
import '../domain/dto/user_credentials.dart';
import '../domain/dto/user_login_response.dart';
import '../domain/repository/user_repository.dart';

class LoginUseCase
    implements UseCase<UserLoginResponseDTO, UserCredentialsDTO> {
  final LoginRepository _loginRepository;
  final SharedPrefsHelper _prefsHelper;

  LoginUseCase(this._loginRepository, this._prefsHelper);

  @override
  Future<UserLoginResponseDTO> execute(UserCredentialsDTO credentials) async {
    try {
      final response = await _loginRepository.execute(credentials);

      await _prefsHelper.saveToken(response.accessToken);

      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
