import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../../../core/error/failure.dart';

class SearchBooksUseCase {
  const SearchBooksUseCase(this._repository);

  final BookRepository _repository;

  Future<({List<Book>? data, Failure? failure})> call(String query) {
    return _repository.searchBooks(query.trim());
  }
}
