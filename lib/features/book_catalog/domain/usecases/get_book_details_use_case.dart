import '../../../../core/error/failure.dart';
import '../entities/book_details.dart';
import '../repositories/book_repository.dart';

class GetBookDetailsUseCase {
  const GetBookDetailsUseCase(this._repository);

  final BookRepository _repository;

  Future<({BookDetails? data, Failure? failure})> call(String workId) {
    return _repository.getBookDetails(workId.trim());
  }
}
