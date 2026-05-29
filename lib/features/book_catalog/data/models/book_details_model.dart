import '../../domain/entities/book_details.dart';

class BookDetailsModel extends BookDetails {
  const BookDetailsModel({
    required super.workId,
    required super.title,
    required super.description,
    required super.subjects,
    required super.coverId,
    required super.authorNames,
    super.publishYear,
    super.numberOfPages,
  });

  factory BookDetailsModel.fromWorkJson(
    Map<String, dynamic> json, {
    required String workId,
    List<String> authorNames = const <String>[],
    int? publishYear,
    int? numberOfPages,
  }) {
    return BookDetailsModel(
      workId: workId,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled',
      description: _parseDescription(json['description']),
      subjects: ((json['subjects'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<String>()
          .map((String subject) => subject.trim())
          .where((String subject) => subject.isNotEmpty)
          .toList(),
      coverId: parseCoverId(json['covers']),
      authorNames: authorNames,
      publishYear: publishYear ?? parseYear(json['first_publish_date']),
      numberOfPages: numberOfPages,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'subjects': subjects,
      'covers': coverId == null ? <int>[] : <int>[coverId!],
      'authorNames': authorNames,
      'publishYear': publishYear,
      'numberOfPages': numberOfPages,
    };
  }

  static String _parseDescription(Object? rawDescription) {
    if (rawDescription is String && rawDescription.trim().isNotEmpty) {
      return rawDescription.trim();
    }

    if (rawDescription is Map<String, dynamic>) {
      final String? value = rawDescription['value'] as String?;
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return 'No description available.';
  }

  static int? parseCoverId(Object? rawCovers) {
    if (rawCovers is List<dynamic>) {
      for (final Object? item in rawCovers) {
        if (item is int) {
          return item;
        }
      }
    }
    return null;
  }

  static int? parseYear(Object? raw) {
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

  static int? parsePageCount(Object? raw) {
    if (raw is int && raw > 0) {
      return raw;
    }
    if (raw is String) {
      return int.tryParse(raw);
    }
    return null;
  }
}
