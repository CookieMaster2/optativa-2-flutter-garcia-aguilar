import 'package:flutter/material.dart';
import 'package:garcia_daniel_parcial2_movilhibrido/modules/search/domain/repository/search_repository.dart';
import 'package:garcia_daniel_parcial2_movilhibrido/modules/search/useCase/search_usecase.dart';
import '../infrastructure/app/localstorage.dart';
import '../infrastructure/connection/connection.dart';
import '../modules/login/domain/repository/user_repository.dart';
import '../modules/login/useCase/login_usecase.dart';
import '../modules/products/domain/repository/category_repository.dart';
import '../modules/products/useCase/categories_usecase.dart';
import '../screens/categories.dart';
import '../screens/login.dart';
import 'rutas.dart';

class ListaDeRutas {
  static final Connection connection = Connection();
  static final SharedPrefsHelper prefsHelper = SharedPrefsHelper();

  static final CategoryRepository categoryRepository =
      CategoryRepository(connection);
  static final GetCategoriesUseCase getCategoriesUseCase =
      GetCategoriesUseCase(categoryRepository);

  static final SearchRepository searchRepository = SearchRepository(connection);
  static final SearchProductsUseCase searchProductsUseCase =
      SearchProductsUseCase(searchRepository);

  static final LoginRepository loginRepository = LoginRepository(connection);
  static final LoginUseCase loginUseCase =
      LoginUseCase(loginRepository, prefsHelper);

  static final Map<String, Widget Function(BuildContext)> listaPantallas = {
    Rutas.login: (context) => Login(
          loginUseCase: loginUseCase,
          getCategoriesUseCase: getCategoriesUseCase,
          searchProductsUseCase: searchProductsUseCase,
        ),
    Rutas.categories: (context) => Categories(
          getCategoriesUseCase: getCategoriesUseCase,
          searchProductsUseCase: searchProductsUseCase,
        ),
  };
}
