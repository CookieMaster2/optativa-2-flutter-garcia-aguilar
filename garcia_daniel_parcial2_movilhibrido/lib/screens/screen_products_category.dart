import 'package:flutter/material.dart';
import '../infrastructure/connection/connection.dart';
import '../modules/products/domain/dto/product_summary.dart';
import '../modules/products/domain/dto/products_by_category.dart';
import '../modules/products/domain/repository/products_category_repository.dart';
import '../modules/products/useCase/products_by_category_usecase.dart';
import 'screen_product_detail.dart';

class Products extends StatelessWidget {
  final String categorySlug;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  Products({
    required this.categorySlug,
    super.key,
  }) : getProductsByCategoryUseCase = GetProductsByCategoryUseCase(
          ProductRepository(Connection()),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: FutureBuilder<ProductsByCategoryDTO>(
        future: getProductsByCategoryUseCase.execute(categorySlug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading products"));
          }
          {
            final products = snapshot.data!.products;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductGridItem(product: product);
              },
            );
          }
        },
      ),
    );
  }
}

class ProductGridItem extends StatelessWidget {
  final ProductSummaryDTO product;

  const ProductGridItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(productId: product.id),
                ),
              );
            },
            child: const Text("Detalles", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
