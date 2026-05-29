import '../entities/library_entry.dart';

abstract class LibraryRepository {
  Stream<List<LibraryEntry>> watchLibrary(String userId);

  Future<void> upsertEntry({
    required String userId,
    required LibraryEntry entry,
  });

  Future<void> deleteEntry({
    required String userId,
    required String workId,
  });
}
