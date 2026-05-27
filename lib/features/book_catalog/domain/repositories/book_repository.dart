import '../../../../core/error/failure.dart';
import '../entities/book.dart';
import '../entities/book_details.dart';

abstract class BookRepository {
  Future<({List<Book>? data, Failure? failure})> searchBooks(String query);

  Future<({BookDetails? data, Failure? failure})> getBookDetails(String workId);
}
