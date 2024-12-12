import '../../../infrastructure/app/use_case.dart';
import '../domain/dto/search_results-dto.dart';
import '../domain/repository/search_repository.dart';

class SearchProductsUseCase implements UseCase<SearchResultDTO, String> {
  final SearchRepository searchRepository;

  SearchProductsUseCase(this.searchRepository);

  @override
  Future<SearchResultDTO> execute(String query) async {
    return await searchRepository.execute(query);
  }
}
