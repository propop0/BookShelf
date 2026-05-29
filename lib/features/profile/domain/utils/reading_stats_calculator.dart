import '../../../library/domain/entities/library_entry.dart';
import '../../../library/domain/entities/reading_status.dart';
import '../entities/reading_stats.dart';
import 'favorite_genre_selector.dart';

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

    final String? favoriteGenre = FavoriteGenreSelector.fromEntries(entries);

    return ReadingStats(
      booksRead: readBooks.length,
      averageRating: averageRating,
      favoriteGenre: favoriteGenre,
    );
  }
}
