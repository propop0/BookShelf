import 'package:flutter/foundation.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/book_details.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/google_books_remote_data_source.dart';
import '../datasources/open_library_remote_data_source.dart';
import '../models/book_model.dart';

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
        _remoteDataSource.searchBooks(query).catchError((e) {
          debugPrint('OpenLibrary search error: $e');
          return <BookModel>[];
        }),
        _googleBooksDataSource.searchBooks(query).catchError((e) {
          debugPrint('GoogleBooks search error: $e');
          return <BookModel>[];
        }),
      ]);

      final List<BookModel> olBooks = results[0];
      final List<BookModel> gbBooks = results[1];

      // De-duplicate: Keep OpenLibrary version if title+author matches exactly
      final Map<String, Book> uniqueBooks = {};

      // 1. Add OpenLibrary books first (Priority)
      for (final book in olBooks) {
        final key = _generateDedupeKey(book);
        uniqueBooks[key] = book;
      }

      // 2. Add Google Books only if not already present
      for (final book in gbBooks) {
        final key = _generateDedupeKey(book);
        if (!uniqueBooks.containsKey(key)) {
          uniqueBooks[key] = book;
        }
      }

      final List<Book> finalResults = uniqueBooks.values.toList();
      
      return (data: finalResults, failure: null);
    } on AppException catch (exception) {
      return (data: null, failure: Failure(exception.message));
    } catch (e, stack) {
      debugPrint('Search error: $e\n$stack');
      return (data: null, failure: Failure('Search failed: ${e.toString()}'));
    }
  }

  String _generateDedupeKey(Book book) {
    final title = book.title.toLowerCase().trim();
    final authors = book.authorNames.join(',').toLowerCase().trim();
    return '$title|$authors';
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
