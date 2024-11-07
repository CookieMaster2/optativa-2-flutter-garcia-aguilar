import 'package:flutter/material.dart';
import '../infrastructure/connection/connection.dart';
import '../modules/products/domain/repository/category_repository.dart';
import '../modules/products/useCase/categories_usecase.dart';
import '../screens/categories.dart';
import '../screens/login.dart';
import 'rutas.dart';

class ListaDeRutas {
  static final Connection connection = Connection();

  static final CategoryRepository categoryRepository =
      CategoryRepository(connection);
  static final GetCategoriesUseCase getCategoriesUseCase =
      GetCategoriesUseCase(categoryRepository); 

  static final Map<String, Widget Function(BuildContext)> listaPantallas = {
    Rutas.login: (context) => const Login(),
    Rutas.categories: (context) => Categories(
          getCategoriesUseCase: getCategoriesUseCase,
        ),

  };
}
