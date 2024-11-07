import 'package:garcia_daniel_parcial2_movilhibrido/infrastructure/app/repository.dart';
import '../../../../infrastructure/connection/connection.dart';
import '../dto/products_by_id.dart';

class ProductDetailRepository implements Repository<ProductDetailDTO, int> {
  final String baseUrl = "https://dummyjson.com/products/";
  final Connection _connection;

  ProductDetailRepository(this._connection);

  @override
  Future<ProductDetailDTO> execute(int productId) async {
    try {
      final jsonMap = await _connection.get<Map<String, dynamic>>('$baseUrl$productId');
      return ProductDetailDTO.fromJson(jsonMap);
    } catch (e) {
      throw Exception('No se pudo cargar el producto $productId: $e');
    }
  }
}
