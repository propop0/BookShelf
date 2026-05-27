import '../../../../core/constants/api_constants.dart';

class BookDetails {
  const BookDetails({
    required this.workId,
    required this.title,
    required this.description,
    required this.subjects,
    required this.coverId,
  });

  final String workId;
  final String title;
  final String description;
  final List<String> subjects;
  final int? coverId;

  String? get coverUrl =>
      coverId == null ? null : ApiConstants.largeCoverUrl(coverId!);
}
