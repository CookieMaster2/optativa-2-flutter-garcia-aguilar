class CategoryDTO {
  final String slug;
  final String name;
  final String url;

  CategoryDTO({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      slug: json['slug'],
      name: json['name'],
      url: json['url'],
    );
  }

  static List<CategoryDTO> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CategoryDTO.fromJson(json)).toList();
  }
}
