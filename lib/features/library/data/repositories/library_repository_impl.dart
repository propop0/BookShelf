import '../../domain/entities/library_entry.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/firestore_library_data_source.dart';
import '../models/library_entry_model.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  const LibraryRepositoryImpl(this._dataSource);

  final FirestoreLibraryDataSource _dataSource;

  @override
  Stream<List<LibraryEntry>> watchLibrary(String userId) {
    return _dataSource.watchLibrary(userId);
  }

  @override
  Future<void> upsertEntry({
    required String userId,
    required LibraryEntry entry,
  }) {
    return _dataSource.upsertEntry(
      userId: userId,
      entry: LibraryEntryModel(
        workId: entry.workId,
        title: entry.title,
        authors: entry.authors,
        status: entry.status,
        coverUrl: entry.coverUrl,
        rating: entry.rating,
        review: entry.review,
        currentPage: entry.currentPage,
        numberOfPages: entry.numberOfPages,
        primarySubject: entry.primarySubject,
        updatedAt: entry.updatedAt,
      ),
    );
  }

  @override
  Future<void> deleteEntry({
    required String userId,
    required String workId,
  }) {
    return _dataSource.deleteEntry(userId: userId, workId: workId);
  }
}
