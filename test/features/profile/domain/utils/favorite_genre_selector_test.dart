import 'package:bookshelf/features/library/domain/entities/library_entry.dart';
import 'package:bookshelf/features/library/domain/entities/reading_status.dart';
import 'package:bookshelf/features/profile/domain/utils/favorite_genre_selector.dart';
import 'package:flutter_test/flutter_test.dart';

LibraryEntry _entry({
  required String workId,
  ReadingStatus status = ReadingStatus.read,
  int? rating,
  String? primarySubject,
}) {
  return LibraryEntry(
    workId: workId,
    title: workId,
    authors: 'Author',
    status: status,
    rating: rating,
    primarySubject: primarySubject,
  );
}

void main() {
  group('FavoriteGenreSelector', () {
    test('returns null when there is no taste signal', () {
      expect(FavoriteGenreSelector.fromEntries(<LibraryEntry>[]), isNull);
      expect(
        FavoriteGenreSelector.fromEntries(<LibraryEntry>[
          _entry(
            workId: '1',
            status: ReadingStatus.wantToRead,
            primarySubject: 'Fantasy',
          ),
        ]),
        isNull,
      );
    });

    test('ignores want-to-read and uses only finished or in-progress books', () {
      final String? genre = FavoriteGenreSelector.fromEntries(<LibraryEntry>[
        _entry(
          workId: 'want',
          status: ReadingStatus.wantToRead,
          primarySubject: 'Horror',
          rating: 10,
        ),
        _entry(
          workId: 'read',
          status: ReadingStatus.read,
          primarySubject: 'Mystery',
          rating: 7,
        ),
      ]);

      expect(genre, 'Mystery');
    });

    test('prefers consistently high-rated genre over higher volume of weak likes', () {
      final String? genre = FavoriteGenreSelector.fromEntries(<LibraryEntry>[
        _entry(workId: 'f1', primarySubject: 'Fantasy', rating: 5),
        _entry(workId: 'f2', primarySubject: 'Fantasy', rating: 6),
        _entry(workId: 'f3', primarySubject: 'Fantasy', rating: 5),
        _entry(workId: 'f4', primarySubject: 'Fantasy', rating: 6),
        _entry(workId: 'm1', primarySubject: 'Mystery', rating: 9),
        _entry(workId: 'm2', primarySubject: 'Mystery', rating: 9),
      ]);

      expect(genre, 'Mystery');
    });

    test('normalizes hierarchical Open Library subjects to the same genre key', () {
      final String? genre = FavoriteGenreSelector.fromEntries(<LibraryEntry>[
        _entry(
          workId: '1',
          primarySubject: 'Fiction : Science fiction',
          rating: 8,
        ),
        _entry(workId: '2', primarySubject: 'Science fiction', rating: 9),
      ]);

      expect(genre, 'Science fiction');
    });

    test('gives partial weight to currently reading books', () {
      final String? genre = FavoriteGenreSelector.fromEntries(<LibraryEntry>[
        _entry(
          workId: 'read-low',
          primarySubject: 'History',
          rating: 4,
        ),
        _entry(
          workId: 'read-low-2',
          primarySubject: 'History',
          rating: 4,
        ),
        _entry(
          workId: 'reading-high',
          status: ReadingStatus.reading,
          primarySubject: 'Poetry',
          rating: 10,
        ),
        _entry(
          workId: 'read-poetry-1',
          primarySubject: 'Poetry',
          rating: 9,
        ),
        _entry(
          workId: 'read-poetry-2',
          primarySubject: 'Poetry',
          rating: 9,
        ),
      ]);

      expect(genre, 'Poetry');
    });

    test('counts finished books without a rating with a moderate default', () {
      final String? genre = FavoriteGenreSelector.fromEntries(<LibraryEntry>[
        _entry(workId: 'rated', primarySubject: 'Biography', rating: 4),
        _entry(workId: 'unrated-1', primarySubject: 'Romance'),
        _entry(workId: 'unrated-2', primarySubject: 'Romance'),
        _entry(workId: 'unrated-3', primarySubject: 'Romance'),
      ]);

      expect(genre, 'Romance');
    });
  });
}
