import 'dart:convert';
import 'package:garcia_daniel_parcial2_movilhibrido/modules/products/domain/dto/products_by_category.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/app/repository.dart';

class ProductRepository
    implements Repository<List<ProductsByCategoryDTO>, String> {
  final String baseUrl = "https://dummyjson.com/products/category/";

  @override
  Future<List<ProductsByCategoryDTO>> execute(String categorySlug) async {
    final response = await http.get(Uri.parse('$baseUrl$categorySlug'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => ProductsByCategoryDTO.fromJson(json))
          .toList();
    } else {
      throw Exception('No se pueden cargar los productos de la categoría $categorySlug');
    }
  }
}
