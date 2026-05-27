import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../book_catalog/domain/entities/book.dart';
import '../../../book_catalog/domain/usecases/search_books_use_case.dart';

final searchBooksNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SearchBooksNotifier, List<Book>>(
  SearchBooksNotifier.new,
);

class SearchBooksNotifier extends AutoDisposeAsyncNotifier<List<Book>> {
  late final SearchBooksUseCase _searchBooksUseCase;
  String _lastQuery = '';

  @override
  FutureOr<List<Book>> build() {
    _searchBooksUseCase = ref.watch(searchBooksUseCaseProvider);
    return <Book>[];
  }

  String get lastQuery => _lastQuery;

  Future<void> search(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = AsyncError<List<Book>>(
        Exception('Search query is empty.'),
        StackTrace.current,
      );
      return;
    }

    _lastQuery = trimmed;
    state = const AsyncLoading<List<Book>>();

    final ({List<Book>? data, Failure? failure}) result = await _searchBooksUseCase(
      trimmed,
    );

    if (result.failure != null) {
      state = AsyncError<List<Book>>(
        Exception(result.failure!.message),
        StackTrace.current,
      );
      return;
    }

    state = AsyncData<List<Book>>(result.data ?? <Book>[]);
  }

  Future<void> retry() async {
    if (_lastQuery.isNotEmpty) {
      await search(_lastQuery);
    }
  }
}
