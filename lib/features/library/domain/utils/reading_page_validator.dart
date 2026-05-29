class ReadingPageValidator {
  const ReadingPageValidator._();

  static bool currentExceedsTotal({
    required int? currentPage,
    required int? totalPages,
  }) {
    if (currentPage == null || totalPages == null || totalPages <= 0) {
      return false;
    }
    return currentPage > totalPages;
  }

  static bool totalBelowCurrent({
    required int? currentPage,
    required int? totalPages,
  }) {
    if (currentPage == null || totalPages == null || totalPages <= 0) {
      return false;
    }
    return totalPages < currentPage;
  }
}
