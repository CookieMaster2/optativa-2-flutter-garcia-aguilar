import 'package:flutter/material.dart';
import 'package:garcia_daniel_parcial2_movilhibrido/routes/lista_de_rutas.dart';
import 'package:garcia_daniel_parcial2_movilhibrido/routes/rutas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.blue)),
        initialRoute: Rutas.login,
        routes: ListaDeRutas.listaPantallas);
  }
}
