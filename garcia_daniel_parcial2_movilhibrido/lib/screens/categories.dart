import 'package:flutter/material.dart';
import '../modules/products/domain/dto/products_category.dart';
import '../modules/products/useCase/categories_usecase.dart';
import 'cart.dart';
import 'screen_products_category.dart';

class Categories extends StatelessWidget {
  final GetCategoriesUseCase getCategoriesUseCase;

  const Categories({required this.getCategoriesUseCase, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorias"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Cart(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CategoryDTO>>(
        future: getCategoriesUseCase.execute(null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar las categorías"));
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
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image,
                    color: Colors.red, size: 40);
              },
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
