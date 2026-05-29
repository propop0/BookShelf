import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../models/library_entry_model.dart';

class FirestoreLibraryDataSource {
  const FirestoreLibraryDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<LibraryEntryModel>> watchLibrary(String userId) {
    return _firestore
        .collection(FirestoreConstants.libraryCollection(userId))
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(LibraryEntryModel.fromFirestore)
              .toList(),
        );
  }

  Future<void> upsertEntry({
    required String userId,
    required LibraryEntryModel entry,
  }) {
    return _firestore
        .doc(FirestoreConstants.libraryDoc(userId, entry.workId))
        .set(entry.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteEntry({
    required String userId,
    required String workId,
  }) {
    return _firestore
        .doc(FirestoreConstants.libraryDoc(userId, workId))
        .delete();
  }
}
