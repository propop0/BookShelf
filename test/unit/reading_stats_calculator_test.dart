import 'package:bookshelf/features/library/domain/entities/library_entry.dart';
import 'package:bookshelf/features/library/domain/entities/reading_status.dart';
import 'package:bookshelf/features/profile/domain/utils/reading_stats_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingStatsCalculator', () {
    test('calculates basic stats correctly', () {
      final entries = [
        LibraryEntry(workId: '1', title: 'A', authors: 'X', status: ReadingStatus.read, rating: 8, primarySubject: 'Fantasy'),
        LibraryEntry(workId: '2', title: 'B', authors: 'Y', status: ReadingStatus.read, rating: 10, primarySubject: 'Fantasy'),
        LibraryEntry(workId: '3', title: 'C', authors: 'Z', status: ReadingStatus.reading, primarySubject: 'Sci-Fi'),
      ];

      final stats = ReadingStatsCalculator.fromEntries(entries);

      expect(stats.booksRead, 2);
      expect(stats.averageRating, 9.0);
      expect(stats.favoriteGenre, 'Fantasy');
    });

    test('handles empty list', () {
      final stats = ReadingStatsCalculator.fromEntries([]);
      expect(stats.booksRead, 0);
      expect(stats.averageRating, isNull);
      expect(stats.favoriteGenre, isNull);
    });
  });
}
