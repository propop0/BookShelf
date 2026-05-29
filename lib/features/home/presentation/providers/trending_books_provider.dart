import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../book_catalog/domain/entities/book.dart';

final trendingBooksProvider = FutureProvider<List<Book>>((ref) async {
  final result = await ref.watch(getTrendingBooksUseCaseProvider)();
  if (result.failure != null) {
    throw Exception(result.failure!.message);
  }
  return result.data ?? <Book>[];
});
