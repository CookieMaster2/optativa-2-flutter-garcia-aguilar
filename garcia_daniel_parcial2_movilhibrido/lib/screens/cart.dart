import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartScreenState();
}

class _CartScreenState extends State<Cart> {
  List<Map<String, dynamic>> _cartItems = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getStringList('cart_items') ?? [];

    setState(() {
      _cartItems = cartItemsString
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });

    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double total = 0.0;
    for (var item in _cartItems) {
      final itemPrice = item['price'] as double? ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      total += itemPrice * quantity;
    }

    setState(() {
      _totalPrice = total;
    });
  }

  void _removeFromCart(int index) async {
    setState(() {
      _cartItems.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    final updatedCartItems =
        _cartItems.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('cart_items', updatedCartItems);

    _calculateTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Total: \$${_totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: _cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text("Quantity: ${item['quantity']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart,
                        color: Colors.red),
                    onPressed: () => _removeFromCart(index),
                  ),
                );
              },
            ),
    );
  }
}
