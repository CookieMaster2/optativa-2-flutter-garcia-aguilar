import 'product_summary.dart';

class ProductsByCategoryDTO {
  final int total;
  final int skip;
  final int limit;
  final List<ProductSummaryDTO> products;

  ProductsByCategoryDTO({
    required this.total,
    required this.skip,
    required this.limit,
    required this.products,
  });

  factory ProductsByCategoryDTO.fromJson(Map<String, dynamic> json) {
    return ProductsByCategoryDTO(
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
      products: (json['products'] as List)
          .map((productJson) => ProductSummaryDTO.fromJson(productJson))
          .toList(),
    );
  }
}
