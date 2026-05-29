import '../../../library/domain/entities/library_entry.dart';
import '../../../library/domain/entities/reading_status.dart';
import '../entities/reading_stats.dart';

class ReadingStatsCalculator {
  const ReadingStatsCalculator._();

  static ReadingStats fromEntries(List<LibraryEntry> entries) {
    final List<LibraryEntry> readBooks = entries
        .where((entry) => entry.status == ReadingStatus.read)
        .toList();

    final List<int> ratings = readBooks
        .map((entry) => entry.rating)
        .whereType<int>()
        .toList();

    final double? averageRating = ratings.isEmpty
        ? null
        : ratings.reduce((a, b) => a + b) / ratings.length;

    final Map<String, int> genreCounts = <String, int>{};
    for (final LibraryEntry entry in entries) {
      final String? genre = entry.primarySubject;
      if (genre != null && genre.isNotEmpty) {
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      }
    }

    String? favoriteGenre;
    if (genreCounts.isNotEmpty) {
      favoriteGenre = genreCounts.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }

    return ReadingStats(
      booksRead: readBooks.length,
      averageRating: averageRating,
      favoriteGenre: favoriteGenre,
    );
  }
}
