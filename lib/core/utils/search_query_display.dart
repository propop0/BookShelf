import '../../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../../features/home/domain/constants/book_categories.dart';

/// Formats search queries for UI (e.g. subject filters vs free-text search).
class SearchQueryDisplay {
  const SearchQueryDisplay._();

  static String appBarTitle(AppLocalizations l10n, String rawQuery) {
    final String query = rawQuery.trim();
    final String? category = localizedCategoryName(l10n, query);
    if (category != null) {
      return l10n.searchCategoryTitle(category);
    }
    return l10n.searchResultsTitle(query);
  }

  static bool isSubjectQuery(String rawQuery) => subjectKey(rawQuery) != null;

  static String? subjectKey(String rawQuery) {
    final String query = rawQuery.trim();
    final RegExpMatch? match = RegExp(
      r'^subject:\s*(.+)$',
      caseSensitive: false,
    ).firstMatch(query);
    if (match == null) {
      return null;
    }
    return match.group(1)!.trim().toLowerCase().replaceAll('_', ' ');
  }

  static String? localizedCategoryName(AppLocalizations l10n, String rawQuery) {
    final String? key = subjectKey(rawQuery);
    if (key == null) {
      return null;
    }

    for (final BookCategory category in popularBookCategories) {
      final String slug = category.searchQuery
          .replaceFirst(RegExp(r'^subject:', caseSensitive: false), '')
          .trim()
          .toLowerCase();
      if (slug == key || slug.replaceAll('_', ' ') == key) {
        return category.localizedLabel(l10n);
      }
    }

    return _titleCase(key);
  }

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
