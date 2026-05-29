/// Formats search queries for UI (e.g. subject filters vs free-text search).
class SearchQueryDisplay {
  const SearchQueryDisplay._();

  static String appBarTitle(String rawQuery) {
    final String query = rawQuery.trim();
    final String? category = categoryLabel(query);
    if (category != null) {
      return 'Category: $category';
    }
    return 'Results: "$query"';
  }

  /// Returns a human-readable category name for `subject:…` queries.
  static String? categoryLabel(String rawQuery) {
    final String query = rawQuery.trim();
    final RegExpMatch? match = RegExp(
      r'^subject:\s*(.+)$',
      caseSensitive: false,
    ).firstMatch(query);
    if (match == null) {
      return null;
    }

    final String subject = match.group(1)!.trim();
    if (subject.isEmpty) {
      return null;
    }

    return _titleCase(subject.replaceAll('_', ' '));
  }

  static bool isSubjectQuery(String rawQuery) => categoryLabel(rawQuery) != null;

  static String _titleCase(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .map((String part) {
          if (part.length == 1) {
            return part.toUpperCase();
          }
          return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}
