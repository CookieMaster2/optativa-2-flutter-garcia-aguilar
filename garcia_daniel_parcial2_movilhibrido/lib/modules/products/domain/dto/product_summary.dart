class ProductSummaryDTO {
  final int id;
  final String title;
  final double price;
  final String category;
  final String imageUrl;

  ProductSummaryDTO({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  factory ProductSummaryDTO.fromJson(Map<String, dynamic> json) {
    return ProductSummaryDTO(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }
}
