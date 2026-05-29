import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../book_catalog/domain/entities/book_details.dart';
import '../../../../core/providers/app_providers.dart';

/// Fetches Open Library metadata to enrich library entries (e.g. page count).
final libraryBookDetailsProvider = FutureProvider.autoDispose
    .family<BookDetails?, String>((ref, String workId) async {
  if (workId.trim().isEmpty) {
    return null;
  }

  final result = await ref.read(getBookDetailsUseCaseProvider)(workId);
  return result.data;
});
