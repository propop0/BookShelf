import '../../../book_catalog/domain/entities/book.dart';

abstract class SearchCacheRepository {
  Future<String?> getLastSearchQuery();

  Future<void> saveLastSearchQuery(String query);

  Future<List<Book>?> getCachedBooks(String query);

  Future<void> saveCachedBooks(String query, List<Book> books);

  Future<void> clearCacheForQuery(String query);
}
