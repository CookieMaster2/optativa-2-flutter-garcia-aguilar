import 'package:garcia_daniel_parcial2_movilhibrido/modules/products/domain/dto/product_summary.dart';

class SearchResultDTO {
  final int total;
  final int skip;
  final int limit;
  final List<ProductSummaryDTO> products;

  SearchResultDTO({
    required this.total,
    required this.skip,
    required this.limit,
    required this.products,
  });

  factory SearchResultDTO.fromJson(Map<String, dynamic> json) {
    return SearchResultDTO(
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
      products: (json['products'] as List)
          .map((productJson) => ProductSummaryDTO.fromJson(productJson))
          .toList(),
    );
  }
}