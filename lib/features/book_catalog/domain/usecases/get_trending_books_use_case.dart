import '../../../../core/error/failure.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetTrendingBooksUseCase {
  const GetTrendingBooksUseCase(this._repository);

  final BookRepository _repository;

  Future<({List<Book>? data, Failure? failure})> call() {
    return _repository.getTrendingBooks();
  }
}
