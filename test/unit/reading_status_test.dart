import 'package:bookshelf/features/library/domain/entities/reading_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingStatus', () {
    test('fromFirestore mapping', () {
      expect(ReadingStatus.fromFirestore('reading'), ReadingStatus.reading);
      expect(ReadingStatus.fromFirestore('read'), ReadingStatus.read);
      expect(ReadingStatus.fromFirestore('want_to_read'), ReadingStatus.wantToRead);
      expect(ReadingStatus.fromFirestore('unknown'), ReadingStatus.wantToRead);
    });

    test('firestoreValue mapping', () {
      expect(ReadingStatus.reading.firestoreValue, 'reading');
      expect(ReadingStatus.read.firestoreValue, 'read');
      expect(ReadingStatus.wantToRead.firestoreValue, 'want_to_read');
    });
  });
}
