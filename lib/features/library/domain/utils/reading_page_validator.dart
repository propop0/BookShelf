class ReadingPageValidator {
  const ReadingPageValidator._();

  static String? currentPageExceedsTotal({
    required int? currentPage,
    required int? totalPages,
  }) {
    if (currentPage == null || totalPages == null || totalPages <= 0) {
      return null;
    }
    if (currentPage > totalPages) {
      return 'Current page cannot exceed $totalPages total pages.';
    }
    return null;
  }

  static String? totalPagesBelowCurrent({
    required int? currentPage,
    required int? totalPages,
  }) {
    if (currentPage == null || totalPages == null || totalPages <= 0) {
      return null;
    }
    if (totalPages < currentPage) {
      return 'Total pages must be at least $currentPage (current page).';
    }
    return null;
  }
}
