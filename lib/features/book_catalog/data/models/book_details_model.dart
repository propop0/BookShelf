import '../../domain/entities/book_details.dart';

class BookDetailsModel extends BookDetails {
  const BookDetailsModel({
    required super.workId,
    required super.title,
    required super.description,
    required super.subjects,
    required super.coverId,
  });

  factory BookDetailsModel.fromJson(Map<String, dynamic> json, {required String workId}) {
    return BookDetailsModel(
      workId: workId,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled',
      description: _parseDescription(json['description']),
      subjects: ((json['subjects'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      coverId: _parseCoverId(json['covers']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'subjects': subjects,
      'covers': coverId == null ? <int>[] : <int>[coverId!],
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

  static int? _parseCoverId(Object? rawCovers) {
    if (rawCovers is List<dynamic>) {
      for (final Object? item in rawCovers) {
        if (item is int) {
          return item;
        }
      }
    }
    return null;
  }
}
