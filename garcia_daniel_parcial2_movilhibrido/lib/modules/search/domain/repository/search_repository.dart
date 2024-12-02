import 'package:garcia_daniel_parcial2_movilhibrido/infrastructure/app/repository.dart';
import '../../../../infrastructure/connection/connection.dart';
import '../dto/search_results-dto.dart';

class SearchRepository implements Repository<SearchResultDTO, String> {
  final String baseUrl = "https://dummyjson.com/products/search";
  final Connection _connection;

  SearchRepository(this._connection);

  @override
  Future<SearchResultDTO> execute(String query) async {
    final String url = "$baseUrl?q=$query";
    try {
      final Map<String, dynamic> json = await _connection.get<Map<String, dynamic>>(url);
      return SearchResultDTO.fromJson(json);
    } catch (e) {
      throw Exception('No se pudo realizar la búsqueda: $e');
    }
  }
}
