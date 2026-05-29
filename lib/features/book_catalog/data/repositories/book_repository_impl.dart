import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/book_details.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/open_library_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(this._remoteDataSource);

  final OpenLibraryRemoteDataSource _remoteDataSource;

  @override
  Future<({List<Book>? data, Failure? failure})> searchBooks(String query) async {
    try {
      final List<Book> books = await _remoteDataSource.searchBooks(query);
      return (data: books, failure: null);
    } on AppException catch (exception) {
      return (data: null, failure: Failure(exception.message));
    } on Exception {
      return (data: null, failure: const Failure('Unexpected error occurred.'));
    }
  }

  @override
  Future<({List<Book>? data, Failure? failure})> getTrendingBooks() async {
    try {
      final List<Book> books = await _remoteDataSource.getTrendingBooks();
      return (data: books, failure: null);
    } on AppException catch (exception) {
      return (data: null, failure: Failure(exception.message));
    } on Exception {
      return (data: null, failure: const Failure('Unexpected error occurred.'));
    }
  }

  @override
  Future<({BookDetails? data, Failure? failure})> getBookDetails(String workId) async {
    try {
      final BookDetails details = await _remoteDataSource.getBookDetails(workId);
      return (data: details, failure: null);
    } on AppException catch (exception) {
      return (data: null, failure: Failure(exception.message));
    } on Exception {
      return (data: null, failure: const Failure('Unexpected error occurred.'));
    }
  }
}
