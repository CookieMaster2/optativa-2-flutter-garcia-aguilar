import '../../../infrastructure/app/use_case.dart';
import '../domain/dto/products_by_category.dart';
import '../domain/repository/products_category_repository.dart';

class GetProductsByCategoryUseCase
    implements UseCase<ProductsByCategoryDTO, String> {
  final ProductRepository productRepository;

  GetProductsByCategoryUseCase(this.productRepository);

  @override
  Future<ProductsByCategoryDTO> execute(String categorySlug) async {
    return await productRepository.execute(categorySlug);
  }
}
