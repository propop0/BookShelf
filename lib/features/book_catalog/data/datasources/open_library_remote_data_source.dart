import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/book_details_model.dart';
import '../models/book_model.dart';

class OpenLibraryRemoteDataSource {
  const OpenLibraryRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<BookModel>> searchBooks(String query) async {
    final Map<String, dynamic> json = await _apiClient.getJson(
      ApiConstants.searchBooksPath(query),
    );
    final List<dynamic> docs = (json['docs'] as List<dynamic>?) ?? <dynamic>[];

    try {
      return docs
          .whereType<Map<String, dynamic>>()
          .map(BookModel.fromOpenLibraryJson)
          .where((BookModel book) => book.workId.isNotEmpty)
          .toList();
    } on Exception {
      throw const ParsingException();
    }
  }

  Future<List<BookModel>> getTrendingBooks() async {
    try {
      final Map<String, dynamic> json = await _apiClient.getJson(
        ApiConstants.trendingDailyPath,
      );
      final List<BookModel> books = _parseBookList(json['works']);
      if (books.isNotEmpty) {
        return books;
      }
    } on AppException {
      // Fall through to search-based trending.
    }

    final Map<String, dynamic> fallbackJson = await _apiClient.getJson(
      ApiConstants.trendingSearchFallbackPath,
    );
    return _parseBookList(fallbackJson['docs']);
  }

  Future<BookDetailsModel> getBookDetails(String workId) async {
    final Map<String, dynamic> workJson = await _apiClient.getJson(
      ApiConstants.workDetailsPath(workId),
    );

    List<String> authorNames = <String>[];
    int? publishYear = BookDetailsModel.parseYear(workJson['first_publish_date']);
    int? numberOfPages;
    int? coverId = BookDetailsModel.parseCoverId(workJson['covers']);

    try {
      final Map<String, dynamic> editionsJson = await _apiClient.getJson(
        ApiConstants.workEditionsPath(workId),
      );
      final Map<String, dynamic>? edition = _firstEdition(editionsJson);
      if (edition != null) {
        authorNames = _parseEditionAuthors(edition);
        numberOfPages = BookDetailsModel.parsePageCount(edition['number_of_pages']);
        publishYear ??= BookDetailsModel.parseYear(edition['publish_date']);
        coverId ??= BookDetailsModel.parseCoverId(edition['covers']);
      }
    } on AppException {
      // Edition metadata is optional.
    }

    if (authorNames.isEmpty) {
      authorNames = await _resolveAuthorNames(workJson['authors']);
    }

    final BookDetailsModel details = BookDetailsModel.fromWorkJson(
      workJson,
      workId: workId,
      authorNames: authorNames,
      publishYear: publishYear,
      numberOfPages: numberOfPages,
    );

    if (coverId != null && details.coverId == null) {
      return BookDetailsModel(
        workId: details.workId,
        title: details.title,
        description: details.description,
        subjects: details.subjects,
        coverId: coverId,
        authorNames: details.authorNames,
        publishYear: details.publishYear,
        numberOfPages: details.numberOfPages,
      );
    }

    return details;
  }

  List<BookModel> _parseBookList(Object? rawList) {
    if (rawList is! List<dynamic>) {
      return <BookModel>[];
    }

    try {
      return rawList
          .whereType<Map<String, dynamic>>()
          .map(BookModel.fromOpenLibraryJson)
          .where((BookModel book) => book.workId.isNotEmpty)
          .toList();
    } on Exception {
      throw const ParsingException();
    }
  }

  Map<String, dynamic>? _firstEdition(Map<String, dynamic> editionsJson) {
    final List<dynamic> entries =
        (editionsJson['entries'] as List<dynamic>?) ?? <dynamic>[];
    if (entries.isEmpty) {
      return null;
    }

    final Object? first = entries.first;
    if (first is Map<String, dynamic>) {
      return first;
    }
    return null;
  }

  List<String> _parseEditionAuthors(Map<String, dynamic> edition) {
    final List<dynamic> rawAuthors =
        (edition['authors'] as List<dynamic>?) ?? <dynamic>[];
    return rawAuthors
        .map((Object? item) {
          if (item is Map<String, dynamic>) {
            return (item['name'] as String?)?.trim();
          }
          return null;
        })
        .whereType<String>()
        .where((String name) => name.isNotEmpty)
        .toList();
  }

  Future<List<String>> _resolveAuthorNames(Object? rawAuthors) async {
    if (rawAuthors is! List<dynamic>) {
      return <String>[];
    }

    final List<String> names = <String>[];
    for (final Object? item in rawAuthors.take(3)) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final Object? author = item['author'];
      if (author is! Map<String, dynamic>) {
        continue;
      }

      final String? key = author['key'] as String?;
      if (key == null || key.isEmpty) {
        continue;
      }

      try {
        final Map<String, dynamic> authorJson = await _apiClient.getJson(
          ApiConstants.authorPath(key),
        );
        final String? name = (authorJson['name'] as String?)?.trim();
        if (name != null && name.isNotEmpty) {
          names.add(name);
        }
      } on AppException {
        continue;
      }
    }

    return names;
  }
}
