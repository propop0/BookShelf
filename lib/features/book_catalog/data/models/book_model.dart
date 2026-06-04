import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.workId,
    required super.title,
    required super.authorNames,
    required super.firstPublishYear,
    super.coverId,
    super.coverUrlOverride,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel.fromOpenLibraryJson(json);
  }

  /// Parses search, trending, and subject API payloads.
  factory BookModel.fromOpenLibraryJson(Map<String, dynamic> json) {
    final List<String> authorNames = _parseAuthorNames(json);
    final String rawKey = (json['key'] as String?) ?? (json['work_key'] as String?) ?? '';

    return BookModel(
      workId: _extractWorkId(rawKey),
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled',
      authorNames: authorNames,
      firstPublishYear: _parseYear(json['first_publish_year']) ??
          _parseYear(json['publish_year']),
      coverId: json['cover_i'] as int? ?? json['cover_id'] as int?,
    );
  }

  static List<String> _parseAuthorNames(Map<String, dynamic> json) {
    final List<dynamic> rawNames = (json['author_name'] as List<dynamic>?) ?? <dynamic>[];
    final List<String> names = rawNames
        .whereType<String>()
        .map((String name) => name.trim())
        .where((String name) => name.isNotEmpty)
        .toList();
    if (names.isNotEmpty) {
      return names;
    }

    final Object? authors = json['authors'];
    if (authors is List<dynamic>) {
      return authors
          .map((Object? item) {
            if (item is String) {
              return item.trim();
            }
            if (item is Map<String, dynamic>) {
              return (item['name'] as String?)?.trim();
            }
            return null;
          })
          .whereType<String>()
          .where((String name) => name.isNotEmpty)
          .toList();
    }

    return <String>[];
  }

  static int? _parseYear(Object? raw) {
    if (raw is int) {
      return raw;
    }
    if (raw is String) {
      final RegExpMatch? match = RegExp(r'(\d{4})').firstMatch(raw);
      if (match != null) {
        return int.tryParse(match.group(1)!);
      }
    }
    return null;
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
