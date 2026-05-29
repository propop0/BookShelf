import 'package:flutter/widgets.dart';

import '../../features/home/domain/constants/book_categories.dart';
import '../../features/library/domain/entities/reading_status.dart';
import '../../features/library/domain/utils/reading_progress.dart';
import '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension ReadingStatusL10n on ReadingStatus {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        ReadingStatus.reading => l10n.statusReading,
        ReadingStatus.read => l10n.statusRead,
        ReadingStatus.wantToRead => l10n.statusWantToRead,
      };
}

extension BookCategoryL10n on BookCategory {
  String localizedLabel(AppLocalizations l10n) => switch (key) {
        BookCategoryKey.fiction => l10n.categoryFiction,
        BookCategoryKey.science => l10n.categoryScience,
        BookCategoryKey.history => l10n.categoryHistory,
        BookCategoryKey.romance => l10n.categoryRomance,
        BookCategoryKey.fantasy => l10n.categoryFantasy,
        BookCategoryKey.mystery => l10n.categoryMystery,
        BookCategoryKey.biography => l10n.categoryBiography,
        BookCategoryKey.children => l10n.categoryChildren,
      };
}

extension ReadingProgressL10n on ReadingProgress {
  String localizedLabel(AppLocalizations l10n) {
    if (totalPages != null && totalPages! > 0 && value != null) {
      return l10n.readingProgressDeterminate(
        currentPage,
        totalPages!,
        (value! * 100).round(),
      );
    }
    return l10n.readingProgressUnknownTotal(currentPage);
  }
}
