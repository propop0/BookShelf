import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/app_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<Map<String, dynamic>> getJson(String path) async {
    final Uri uri = Uri.parse('${ApiConstants.openLibraryBaseUrl}$path');
    http.Response response;

    try {
      response = await _httpClient
          .get(uri, headers: const <String, String>{'Accept': 'application/json'})
          .timeout(ApiConstants.requestTimeout);
    } on Exception {
      throw const NetworkException();
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException('Server returned ${response.statusCode}');
    }

    try {
      final Object? decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw const ParsingException('Expected a JSON object response.');
    } on FormatException {
      throw const ParsingException();
    }
  }
}
