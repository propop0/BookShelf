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
          .map(BookModel.fromJson)
          .where((book) => book.workId.isNotEmpty)
          .toList();
    } on Exception {
      throw const ParsingException();
    }
  }

  Future<BookDetailsModel> getBookDetails(String workId) async {
    final Map<String, dynamic> json = await _apiClient.getJson(
      ApiConstants.workDetailsPath(workId),
    );

    try {
      return BookDetailsModel.fromJson(json, workId: workId);
    } on Exception {
      throw const ParsingException();
    }
  }
}
