import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/book_details.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/google_books_remote_data_source.dart';
import '../datasources/open_library_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(
    this._remoteDataSource,
    this._googleBooksDataSource,
  );

  final OpenLibraryRemoteDataSource _remoteDataSource;
  final GoogleBooksRemoteDataSource _googleBooksDataSource;

  @override
  Future<({List<Book>? data, Failure? failure})> searchBooks(String query) async {
    try {
      final results = await Future.wait([
        _remoteDataSource.searchBooks(query),
        _googleBooksDataSource.searchBooks(query),
      ]);

      final List<Book> books = [...results[0], ...results[1]];

      // De-duplicate if same title and author exists? 
      // For now just merge.

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
