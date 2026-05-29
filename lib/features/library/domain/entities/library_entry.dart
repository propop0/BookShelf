import 'reading_status.dart';

class LibraryEntry {
  const LibraryEntry({
    required this.workId,
    required this.title,
    required this.authors,
    required this.status,
    this.coverUrl,
    this.rating,
    this.review,
    this.currentPage,
    this.primarySubject,
    this.updatedAt,
  });

  final String workId;
  final String title;
  final String authors;
  final ReadingStatus status;
  final String? coverUrl;
  final int? rating;
  final String? review;
  final int? currentPage;
  final String? primarySubject;
  final DateTime? updatedAt;
}
