import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/products/domain/dto/products_category.dart';
import '../modules/products/useCase/categories_usecase.dart';
import '../modules/search/domain/dto/search_results-dto.dart';
import '../modules/search/useCase/search_usecase.dart';
import 'cart.dart';
import 'product_history.dart';
import 'screen_product_detail.dart';
import 'screen_products_category.dart';

class Categories extends StatefulWidget {
  final GetCategoriesUseCase getCategoriesUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  const Categories({
    required this.getCategoriesUseCase,
    required this.searchProductsUseCase,
    super.key,
  });

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  int _selectedIndex = 0;
  Future<List<CategoryDTO>?>? _categoriesFuture;
  Future<SearchResultDTO>? _searchResultFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _checkAccessTokenAndFetchCategories();
  }

  Future<List<CategoryDTO>?> _checkAccessTokenAndFetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('login_token');

    if (accessToken == null) {
      return null;
    }

    return await widget.getCategoriesUseCase.execute(null);
  }

  void _onSearch(String query) {
    setState(() {
      _searchResultFuture = widget.searchProductsUseCase.execute(query);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCurrentScreen() {
  switch (_selectedIndex) {
    case 0: // Search
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _onSearch(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<SearchResultDTO>(
              future: _searchResultFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error al realizar la búsqueda."),
                  );
                } else if (snapshot.data == null || snapshot.data!.products.isEmpty) {
                  return const Center(
                    child: Text("No se encontraron productos."),
                  );
                } else {
                  final products = snapshot.data!.products;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.title),
                        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                        leading: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(productId: product.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      );
    case 1: // Cart
      return const Cart();
    case 2: // Categories
      return FutureBuilder<List<CategoryDTO>?>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar las categorías"));
          } else if (snapshot.data == null) {
            return const Center(
                child: Text("No está autenticado. Por favor inicie sesión."));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryListItem(category: category);
              },
            );
          }
        },
      );
    case 3: // Profile
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Perfil del Usuario"),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserHistoryScreen(),
              ),
            );
          },
          child: const Text("Ver historial de productos"),
        ),
      ],
    ),
  );
    default:
      return const Center(
        child: Text("Pantalla desconocida"),
      );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: "Buscar",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: "Carrito",
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: "Categorías",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final CategoryDTO category;

  const CategoryListItem({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: category.url.isNotEmpty
          ? Image.network(
              category.url,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            )
          : const Icon(Icons.category, color: Colors.blue, size: 40),
      title: Text(
        category.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(category.slug),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Products(categorySlug: category.slug),
          ),
        );
      },
    );
  }
}
