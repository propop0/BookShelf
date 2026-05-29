enum ReadingStatus {
  reading,
  read,
  wantToRead;

  String get label => switch (this) {
        ReadingStatus.reading => 'Reading',
        ReadingStatus.read => 'Read',
        ReadingStatus.wantToRead => 'Want to read',
      };

  String get firestoreValue => switch (this) {
        ReadingStatus.reading => 'reading',
        ReadingStatus.read => 'read',
        ReadingStatus.wantToRead => 'want_to_read',
      };

  static ReadingStatus fromFirestore(String value) {
    return switch (value) {
      'reading' => ReadingStatus.reading,
      'read' => ReadingStatus.read,
      'want_to_read' => ReadingStatus.wantToRead,
      _ => ReadingStatus.wantToRead,
    };
  }
}
