import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/app/repository.dart';
import '../dto/products_by_id.dart';

class ProductDetailRepository implements Repository<ProductDetailDTO, int> {
  final String baseUrl = "https://dummyjson.com/products/";

  @override
  Future<ProductDetailDTO> execute(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl$productId'));

    if (response.statusCode == 200) {
      return ProductDetailDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudo cargar el producto $productId');
    }
  }
}
