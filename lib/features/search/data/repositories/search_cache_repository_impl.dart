import 'package:shared_preferences/shared_preferences.dart';

import '../../../book_catalog/domain/entities/book.dart';
import '../../domain/repositories/search_cache_repository.dart';
import '../datasources/search_cache_local_data_source.dart';

class SearchCacheRepositoryImpl implements SearchCacheRepository {
  SearchCacheRepositoryImpl(this._getPreferences);

  final Future<SharedPreferences> Function() _getPreferences;
  final Map<String, List<Book>> _memoryCache = <String, List<Book>>{};

  Future<SearchCacheLocalDataSource> _dataSource() async {
    final SharedPreferences prefs = await _getPreferences();
    return SearchCacheLocalDataSource(prefs);
  }

  String _normalize(String query) => query.trim().toLowerCase();

  @override
  Future<String?> getLastSearchQuery() async {
    return (await _dataSource()).readLastSearchQuery();
  }

  @override
  Future<void> saveLastSearchQuery(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }
    await (await _dataSource()).writeLastSearchQuery(trimmed);
  }

  @override
  Future<List<Book>?> getCachedBooks(String query) async {
    final String key = _normalize(query);
    final List<Book>? inMemory = _memoryCache[key];
    if (inMemory != null) {
      return inMemory;
    }

    final List<Book>? persisted = (await _dataSource()).readCachedBooks(query);
    if (persisted != null) {
      _memoryCache[key] = persisted;
    }
    return persisted;
  }

  @override
  Future<void> saveCachedBooks(String query, List<Book> books) async {
    final String key = _normalize(query);
    _memoryCache[key] = books;
    await (await _dataSource()).writeCachedBooks(query, books);
  }

  @override
  Future<void> clearCacheForQuery(String query) async {
    _memoryCache.remove(_normalize(query));
    // Persisted entries expire by TTL; no per-query delete needed for MVP.
  }
}
