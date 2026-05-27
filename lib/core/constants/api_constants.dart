class ApiConstants {
  const ApiConstants._();

  static const String openLibraryBaseUrl = 'https://openlibrary.org';
  static const String coversBaseUrl = 'https://covers.openlibrary.org/b/id';
  static const Duration requestTimeout = Duration(seconds: 15);
  static const int searchLimit = 20;

  static String searchBooksPath(String query) {
    final String encoded = Uri.encodeQueryComponent(query);
    return '/search.json?q=$encoded&limit=$searchLimit';
  }

  static String workDetailsPath(String workId) => '/works/$workId.json';

  static String largeCoverUrl(int coverId) => '$coversBaseUrl/$coverId-L.jpg';
}
