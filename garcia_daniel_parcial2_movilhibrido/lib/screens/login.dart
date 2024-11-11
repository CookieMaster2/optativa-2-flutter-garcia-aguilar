import 'package:flutter/material.dart';
import '../modules/login/domain/dto/user_credentials.dart';
import '../modules/login/useCase/login_usecase.dart';
import '../modules/products/useCase/categories_usecase.dart';
import 'categories.dart';

class Login extends StatefulWidget {
  final LoginUseCase loginUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  const Login(
      {super.key,
      required this.loginUseCase,
      required this.getCategoriesUseCase});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _attemptLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Usuario y contraseña no pueden estar vacíos';
      });
      return;
    }

    try {
      final credentials =
          UserCredentialsDTO(user: username, password: password);

      await widget.loginUseCase.execute(credentials);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Categories(
            getCategoriesUseCase: widget.getCategoriesUseCase,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/image.jpg'),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _attemptLogin,
                child: const Text('Ingresar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
