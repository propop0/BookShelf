import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/prefs_keys.dart';
import '../../../book_catalog/data/models/book_model.dart';
import '../../../book_catalog/domain/entities/book.dart';

class SearchCacheLocalDataSource {
  SearchCacheLocalDataSource(this._preferences);

  static const Duration cacheTtl = Duration(hours: 1);
  static const int maxCachedQueries = 15;

  final SharedPreferences _preferences;

  String? readLastSearchQuery() {
    return _preferences.getString(PrefsKeys.lastSearchQuery);
  }

  Future<void> writeLastSearchQuery(String query) async {
    await _preferences.setString(PrefsKeys.lastSearchQuery, query);
  }

  List<Book>? readCachedBooks(String query) {
    final String? raw = _preferences.getString(PrefsKeys.searchResultsCache);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final List<dynamic> entries =
          (decoded['entries'] as List<dynamic>?) ?? <dynamic>[];
      final String normalizedQuery = _normalizeQuery(query);

      for (final Object? entry in entries) {
        if (entry is! Map<String, dynamic>) {
          continue;
        }

        if (_normalizeQuery((entry['query'] as String?) ?? '') != normalizedQuery) {
          continue;
        }

        final int? cachedAtMs = entry['cachedAt'] as int?;
        if (cachedAtMs == null) {
          continue;
        }

        final DateTime cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
        if (DateTime.now().difference(cachedAt) > cacheTtl) {
          return null;
        }

        final List<dynamic> booksJson =
            (entry['books'] as List<dynamic>?) ?? <dynamic>[];
        return booksJson
            .whereType<Map<String, dynamic>>()
            .map(BookModel.fromJson)
            .toList();
      }
    } on FormatException {
      return null;
    }

    return null;
  }

  Future<void> writeCachedBooks(String query, List<Book> books) async {
    final String normalizedQuery = _normalizeQuery(query);
    final Map<String, dynamic> cacheRoot = _readCacheRoot();

    final List<Map<String, dynamic>> entries =
        ((cacheRoot['entries'] as List<dynamic>?) ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .where(
              (Map<String, dynamic> entry) =>
                  _normalizeQuery((entry['query'] as String?) ?? '') !=
                  normalizedQuery,
            )
            .toList();

    entries.insert(0, <String, dynamic>{
      'query': normalizedQuery,
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
      'books': books.map((Book book) => BookModel(
            workId: book.workId,
            title: book.title,
            authorNames: book.authorNames,
            firstPublishYear: book.firstPublishYear,
            coverId: book.coverId,
          ).toJson()).toList(),
    });

    final List<Map<String, dynamic>> trimmed = entries.length > maxCachedQueries
        ? entries.sublist(0, maxCachedQueries)
        : entries;

    cacheRoot['entries'] = trimmed;
    await _preferences.setString(
      PrefsKeys.searchResultsCache,
      jsonEncode(cacheRoot),
    );
  }

  Map<String, dynamic> _readCacheRoot() {
    final String? raw = _preferences.getString(PrefsKeys.searchResultsCache);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{'entries': <dynamic>[]};
    }

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      // Reset corrupt cache.
    }

    return <String, dynamic>{'entries': <dynamic>[]};
  }

  String _normalizeQuery(String query) => query.trim().toLowerCase();
}
