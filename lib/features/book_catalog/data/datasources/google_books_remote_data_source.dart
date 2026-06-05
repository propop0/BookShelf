import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/book_model.dart';

class GoogleBooksRemoteDataSource {
  const GoogleBooksRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final Map<String, dynamic> json = await _apiClient.getJson(
        ApiConstants.searchGoogleBooksPath(query),
        baseUrl: ApiConstants.googleBooksBaseUrl,
      );

      final List<dynamic> items = (json['items'] as List<dynamic>?) ?? <dynamic>[];

      return items
          .whereType<Map<String, dynamic>>()
          .map(_parseBook)
          .where((BookModel book) => book.workId.isNotEmpty)
          .toList();
    } on Exception {
      throw const ParsingException();
    }
  }

  BookModel _parseBook(Map<String, dynamic> json) {
    final Map<String, dynamic> volumeInfo =
        (json['volumeInfo'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    final String id = (json['id'] as String?) ?? '';
    final String title = (volumeInfo['title'] as String?) ?? '';
    final List<dynamic> authors = (volumeInfo['authors'] as List<dynamic>?) ?? <dynamic>[];
    final Map<String, dynamic>? imageLinks =
        (volumeInfo['imageLinks'] as Map<String, dynamic>?);

    // Prefer thumbnail, fall back to smallThumbnail
    String? coverUrl = imageLinks?['thumbnail'] as String? ??
        imageLinks?['smallThumbnail'] as String?;

    // Google Books URLs often use http, but we prefer https
    if (coverUrl != null && coverUrl.startsWith('http:')) {
      coverUrl = coverUrl.replaceFirst('http:', 'https:');
    }

    return BookModel(
      workId: 'gb_$id', // Prefix to distinguish from OpenLibrary
      title: title,
      authorNames: authors.whereType<String>().toList(),
      coverUrlOverride: coverUrl,
      firstPublishYear: _parseYear(volumeInfo['publishedDate'] as String?),
    );
  }

  int? _parseYear(String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }
    // Google Books often returns YYYY or YYYY-MM-DD
    final String yearPart = date.split('-').first;
    return int.tryParse(yearPart);
  }
}
