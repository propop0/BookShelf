class ApiConstants {
  const ApiConstants._();

  static const String openLibraryBaseUrl = 'https://openlibrary.org';
  static const String coversBaseUrl = 'https://covers.openlibrary.org/b/id';
  static const Duration requestTimeout = Duration(seconds: 15);
  static const int searchLimit = 20;

  static const int trendingLimit = 12;
  static const int categoryGridCrossAxisCount = 2;

  static String searchBooksPath(String query) {
    final String encoded = Uri.encodeQueryComponent(query);
    return '/search.json?q=$encoded&limit=$searchLimit';
  }

  static String workDetailsPath(String workId) => '/works/$workId.json';

  static String workEditionsPath(String workId, {int limit = 1}) =>
      '/works/$workId/editions.json?limit=$limit';

  static String authorPath(String authorKey) {
    final String normalized = authorKey.startsWith('/') ? authorKey : '/$authorKey';
    return '$normalized.json';
  }

  static String get trendingDailyPath =>
      '/trending/daily.json?limit=$trendingLimit';

  /// Fallback when the experimental trending endpoint is unavailable.
  static String get trendingSearchFallbackPath =>
      '/search.json?q=trending_score_hourly_sum:[1 TO *]&sort=trending&limit=$trendingLimit';

  static String largeCoverUrl(int coverId) => '$coversBaseUrl/$coverId-L.jpg';
}
