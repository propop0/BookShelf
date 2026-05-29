import '../../../../core/constants/api_constants.dart';

class BookDetails {
  const BookDetails({
    required this.workId,
    required this.title,
    required this.description,
    required this.subjects,
    required this.coverId,
    required this.authorNames,
    this.publishYear,
    this.numberOfPages,
  });

  final String workId;
  final String title;
  final String description;
  final List<String> subjects;
  final int? coverId;
  final List<String> authorNames;
  final int? publishYear;
  final int? numberOfPages;

  String get authorsLabel =>
      authorNames.isEmpty ? 'Unknown author' : authorNames.join(', ');

  String? get coverUrl =>
      coverId == null ? null : ApiConstants.largeCoverUrl(coverId!);
}
