import 'package:garcia_daniel_parcial2_movilhibrido/infrastructure/app/repository.dart';
import '../../../../infrastructure/connection/connection.dart';
import '../dto/products_category.dart';

class CategoryRepository implements Repository<List<CategoryDTO>, void> {
  final String url = "https://dummyjson.com/products/categories";
  final Connection _connection;

  CategoryRepository(this._connection);

  @override
  Future<List<CategoryDTO>> execute(void params) async {
    try {
      final List<dynamic> jsonList = await _connection.get<List<dynamic>>(url);
      return CategoryDTO.fromJsonList(jsonList);
    } catch (e) {
      throw Exception('No se pudieron obtener las categorías: $e');
    }
  }
}
