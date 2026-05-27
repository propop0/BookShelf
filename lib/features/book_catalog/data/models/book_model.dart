import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.workId,
    required super.title,
    required super.authorNames,
    required super.firstPublishYear,
    required super.coverId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawAuthors = (json['author_name'] as List<dynamic>?) ?? <dynamic>[];
    final String rawKey = (json['key'] as String?) ?? '';

    return BookModel(
      workId: _extractWorkId(rawKey),
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled',
      authorNames: rawAuthors.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': '/works/$workId',
      'title': title,
      'author_name': authorNames,
      'first_publish_year': firstPublishYear,
      'cover_i': coverId,
    };
  }

  static String _extractWorkId(String key) {
    if (key.startsWith('/works/')) {
      return key.replaceFirst('/works/', '');
    }
    return key;
  }
}
