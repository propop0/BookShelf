/// UI-ready reading progress for a library entry.
class ReadingProgress {
  const ReadingProgress({
    required this.currentPage,
    this.totalPages,
    this.value,
  });

  final int currentPage;
  final int? totalPages;

  /// `0.0`–`1.0` when total pages are known; `null` = indeterminate bar.
  final double? value;

  bool get isDeterminate => value != null;
}
