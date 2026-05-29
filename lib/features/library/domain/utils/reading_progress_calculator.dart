import '../entities/library_entry.dart';
import '../entities/reading_status.dart';
import 'reading_progress.dart';

class ReadingProgressCalculator {
  const ReadingProgressCalculator._();

  static ReadingProgress? forEntry(
    LibraryEntry entry, {
    int? resolvedTotalPages,
  }) {
    if (entry.status != ReadingStatus.reading) {
      return null;
    }

    final int? currentPage = entry.currentPage;
    if (currentPage == null || currentPage <= 0) {
      return null;
    }

    final int? totalPages = resolvedTotalPages ?? entry.numberOfPages;
    if (totalPages != null && totalPages > 0) {
      final double fraction = (currentPage / totalPages).clamp(0.0, 1.0);
      return ReadingProgress(
        currentPage: currentPage,
        totalPages: totalPages,
        value: fraction,
      );
    }

    return ReadingProgress(
      currentPage: currentPage,
      value: null,
    );
  }
}
