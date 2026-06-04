import '../../../../core/constants/api_constants.dart';

class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authorNames,
    required this.firstPublishYear,
    this.coverId,
    this.coverUrlOverride,
  });

  final String workId;
  final String title;
  final List<String> authorNames;
  final int? firstPublishYear;
  final int? coverId;
  final String? coverUrlOverride;

  String get authorsLabel =>
      authorNames.isEmpty ? 'Unknown author' : authorNames.join(', ');

  String? get coverUrl => coverUrlOverride ??
      (coverId == null ? null : ApiConstants.largeCoverUrl(coverId!));
}
