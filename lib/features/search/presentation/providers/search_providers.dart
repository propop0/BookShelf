import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/repositories/search_cache_repository_impl.dart';
import '../../domain/repositories/search_cache_repository.dart';
import '../../domain/usecases/search_books_use_case.dart';

final searchCacheRepositoryProvider = Provider<SearchCacheRepository>((ref) {
  return SearchCacheRepositoryImpl(
    () => ref.read(sharedPreferencesProvider.future),
  );
});

final searchBooksUseCaseProvider = Provider<SearchBooksUseCase>((ref) {
  return SearchBooksUseCase(
    ref.watch(bookRepositoryProvider),
    ref.watch(searchCacheRepositoryProvider),
  );
});
