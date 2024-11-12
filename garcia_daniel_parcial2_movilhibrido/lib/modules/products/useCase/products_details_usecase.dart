import '../../../infrastructure/app/use_case.dart';
import '../domain/dto/products_by_id.dart';
import '../domain/repository/product_detail_repository.dart';

class GetProductDetailUseCase implements UseCase<ProductDetailDTO, int> {
  final ProductDetailRepository productDetailRepository;

  GetProductDetailUseCase(this.productDetailRepository);

  @override
  Future<ProductDetailDTO> execute(int productId) async {
    return await productDetailRepository.execute(productId);
  }
}
