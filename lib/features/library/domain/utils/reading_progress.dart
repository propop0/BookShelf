/// UI-ready reading progress for a library entry.
class ReadingProgress {
  const ReadingProgress({
    required this.label,
    this.value,
  });

  /// `0.0`–`1.0` when total pages are known; `null` = indeterminate bar.
  final double? value;
  final String label;

  bool get isDeterminate => value != null;
}
