import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../book_catalog/domain/entities/book_details.dart';
import '../../../book_catalog/domain/usecases/get_book_details_use_case.dart';

final bookDetailsNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    BookDetailsNotifier, BookDetails, String>(
  BookDetailsNotifier.new,
);

class BookDetailsNotifier extends AutoDisposeFamilyAsyncNotifier<BookDetails, String> {
  late final GetBookDetailsUseCase _getBookDetailsUseCase;

  @override
  FutureOr<BookDetails> build(String workId) async {
    _getBookDetailsUseCase = ref.watch(getBookDetailsUseCaseProvider);
    return _fetchDetails(workId);
  }

  Future<void> reload() async {
    state = const AsyncLoading<BookDetails>();
    state = await AsyncValue.guard(() => _fetchDetails(arg));
  }

  Future<BookDetails> _fetchDetails(String workId) async {
    final String trimmed = workId.trim();
    if (trimmed.isEmpty) {
      throw Exception('Missing work id.');
    }

    final result = await _getBookDetailsUseCase(trimmed);
    if (result.failure != null) {
      throw Exception(result.failure!.message);
    }

    final BookDetails? details = result.data;
    if (details == null) {
      throw Exception('Book details are unavailable.');
    }
    return details;
  }
}
