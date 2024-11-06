import 'dart:convert';
import 'package:garcia_daniel_parcial2_movilhibrido/infrastructure/app/repository.dart';
import 'package:http/http.dart' as http;
import '../dto/products_category.dart';

class CategoryRepository implements Repository<List<CategoryDTO>, void> {
  final String url = "https://dummyjson.com/products/categories";

  @override
  Future<List<CategoryDTO>> execute(void params) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return CategoryDTO.fromJsonList(jsonList);
    } else {
      throw Exception('No se pudieron obtener las categorías');
    }
  }
}
