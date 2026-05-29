import '../../../../core/error/failure.dart';
import '../../../book_catalog/domain/entities/book.dart';
import '../../../book_catalog/domain/repositories/book_repository.dart';
import '../repositories/search_cache_repository.dart';

class SearchBooksUseCase {
  const SearchBooksUseCase(
    this._bookRepository,
    this._cacheRepository,
  );

  final BookRepository _bookRepository;
  final SearchCacheRepository _cacheRepository;

  Future<({List<Book>? data, Failure? failure})> call(
    String query, {
    bool forceRefresh = false,
  }) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) {
      return (data: null, failure: const Failure('Search query is empty.'));
    }

    if (!forceRefresh) {
      final List<Book>? cached = await _cacheRepository.getCachedBooks(trimmed);
      if (cached != null) {
        return (data: cached, failure: null);
      }
    }

    final ({List<Book>? data, Failure? failure}) result =
        await _bookRepository.searchBooks(trimmed);

    if (result.data != null) {
      await _cacheRepository.saveCachedBooks(trimmed, result.data!);
      await _cacheRepository.saveLastSearchQuery(trimmed);
    }

    return result;
  }
}
