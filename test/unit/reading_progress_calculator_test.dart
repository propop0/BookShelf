import 'package:bookshelf/features/library/domain/entities/library_entry.dart';
import 'package:bookshelf/features/library/domain/entities/reading_status.dart';
import 'package:bookshelf/features/library/domain/utils/reading_progress_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingProgressCalculator', () {
    test('returns null if not in reading status', () {
      final entry = LibraryEntry(
        workId: '1',
        title: 'Book',
        authors: 'Author',
        status: ReadingStatus.read,
      );
      expect(ReadingProgressCalculator.forEntry(entry), isNull);
    });

    test('returns progress with fraction when total pages known', () {
      final entry = LibraryEntry(
        workId: '1',
        title: 'Book',
        authors: 'Author',
        status: ReadingStatus.reading,
        currentPage: 50,
        numberOfPages: 200,
      );
      final progress = ReadingProgressCalculator.forEntry(entry);
      expect(progress, isNotNull);
      expect(progress!.value, 0.25);
    });

    test('prefers resolved total pages over entry pages', () {
      final entry = LibraryEntry(
        workId: '1',
        title: 'Book',
        authors: 'Author',
        status: ReadingStatus.reading,
        currentPage: 50,
        numberOfPages: 100,
      );
      final progress = ReadingProgressCalculator.forEntry(entry, resolvedTotalPages: 200);
      expect(progress!.value, 0.25);
    });
  });
}
