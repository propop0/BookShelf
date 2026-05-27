import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/book_catalog/data/datasources/open_library_remote_data_source.dart';
import '../../features/book_catalog/data/repositories/book_repository_impl.dart';
import '../../features/book_catalog/domain/repositories/book_repository.dart';
import '../../features/book_catalog/domain/usecases/get_book_details_use_case.dart';
import '../../features/book_catalog/domain/usecases/search_books_use_case.dart';
import '../network/api_client.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(httpClient: ref.watch(httpClientProvider));
});

final openLibraryRemoteDataSourceProvider = Provider<OpenLibraryRemoteDataSource>((ref) {
  return OpenLibraryRemoteDataSource(ref.watch(apiClientProvider));
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(ref.watch(openLibraryRemoteDataSourceProvider));
});

final searchBooksUseCaseProvider = Provider<SearchBooksUseCase>((ref) {
  return SearchBooksUseCase(ref.watch(bookRepositoryProvider));
});

final getBookDetailsUseCaseProvider = Provider<GetBookDetailsUseCase>((ref) {
  return GetBookDetailsUseCase(ref.watch(bookRepositoryProvider));
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});
