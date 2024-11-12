import '../../../infrastructure/app/use_case.dart';
import '../domain/dto/products_category.dart';
import '../domain/repository/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryDTO>, void> {
  final CategoryRepository categoryRepository;

  GetCategoriesUseCase(this.categoryRepository);

  @override
  Future<List<CategoryDTO>> execute(void params) async {
    return await categoryRepository.execute(null);
  }
}
