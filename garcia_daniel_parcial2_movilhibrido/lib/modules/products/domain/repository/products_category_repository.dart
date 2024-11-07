import 'package:garcia_daniel_parcial2_movilhibrido/infrastructure/app/repository.dart';
import '../../../../infrastructure/connection/connection.dart';
import '../dto/products_by_category.dart';

class ProductRepository implements Repository<ProductsByCategoryDTO, String> {
  final String baseUrl = "https://dummyjson.com/products/category/";
  final Connection _connection;

  ProductRepository(this._connection);

  @override
  Future<ProductsByCategoryDTO> execute(String categorySlug) async {
    try {
      final jsonMap =
          await _connection.get<Map<String, dynamic>>('$baseUrl$categorySlug');
      return ProductsByCategoryDTO.fromJson(jsonMap);
    } catch (e) {
      throw Exception(
          'No se pudieron cargar los productos de la categoría $categorySlug: $e');
    }
  }
}
