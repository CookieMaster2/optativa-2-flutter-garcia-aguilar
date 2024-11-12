import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../infrastructure/connection/connection.dart';
import '../modules/products/domain/dto/products_by_id.dart';
import '../modules/products/domain/repository/product_detail_repository.dart';
import '../modules/products/useCase/products_details_usecase.dart';

class Details extends StatefulWidget {
  final int productId;

  const Details({required this.productId, Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int _quantity = 1;

  Future<void> _addToCart(ProductDetailDTO product) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getStringList('cart_items') ?? [];

    final cartItem = {
      "title": product.title,
      "price": product.price,
      "quantity": _quantity,
      "id": product.id,
    };

    final cartItemJson = jsonEncode(cartItem);

    cartItems.add(cartItemJson);

    await prefs.setStringList('cart_items', cartItems);

    setState(() {
      _quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ProductDetailRepository(Connection());
    final getProductDetailUseCase = GetProductDetailUseCase(repository);

    final productFuture = getProductDetailUseCase.execute(widget.productId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de producto"),
      ),
      body: FutureBuilder<ProductDetailDTO>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text("Error loading product details: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No details found"));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network(
                      product.thumbnail,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            size: 200, color: Colors.red);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Precio: \$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Stock: ${product.stock}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            : null,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _quantity < product.stock
                            ? () {
                                setState(() {
                                  _quantity++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _quantity > 0 && _quantity <= product.stock
                        ? () => _addToCart(product)
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text("Agregar"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
