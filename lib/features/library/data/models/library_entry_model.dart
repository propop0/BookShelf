import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/library_entry.dart';
import '../../domain/entities/reading_status.dart';

class LibraryEntryModel extends LibraryEntry {
  const LibraryEntryModel({
    required super.workId,
    required super.title,
    required super.authors,
    required super.status,
    super.coverUrl,
    super.rating,
    super.review,
    super.currentPage,
    super.primarySubject,
    super.updatedAt,
  });

  factory LibraryEntryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};
    return LibraryEntryModel(
      workId: snapshot.id,
      title: (data['title'] as String?) ?? 'Untitled',
      authors: (data['authors'] as String?) ?? '',
      status: ReadingStatus.fromFirestore((data['status'] as String?) ?? ''),
      coverUrl: data['coverUrl'] as String?,
      rating: data['rating'] as int?,
      review: data['review'] as String?,
      currentPage: data['currentPage'] as int?,
      primarySubject: data['primarySubject'] as String?,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'workId': workId,
      'title': title,
      'authors': authors,
      'status': status.firestoreValue,
      'coverUrl': coverUrl,
      'rating': rating,
      'review': review,
      'currentPage': currentPage,
      'primarySubject': primarySubject,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
